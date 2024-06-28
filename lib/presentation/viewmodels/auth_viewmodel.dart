import 'package:boostme2/core/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:boostme2/domain/entities/user.dart' as model;
import 'package:boostme2/domain/usecases/users/get_user.dart';
import 'package:boostme2/domain/usecases/users/add_user.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<firebase_auth.User?>>(
        (ref) {
  final getUser = ref.watch(getUserInfoProvider);
  final addUser = ref.watch(addUserProvider);
  return AuthViewModel(getUser: getUser, addUser: addUser);
});

class AuthViewModel extends StateNotifier<AsyncValue<firebase_auth.User?>> {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final GetUser getUser;
  final AddUser addUser;

  AuthViewModel({
    required this.getUser,
    required this.addUser,
  }) : super(const AsyncValue.loading()) {
    _firebaseAuth.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    });
  }

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithGoogle() async {
    print('Signing in with Google...');
    try {
      firebase_auth.UserCredential userCredential;
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _firebaseAuth.signInWithCredential(credential);
      }

      final user = userCredential.user;
      print('User: ${user?.email}');
      if (user != null) {
        // DB에서 유저 정보 확인
        try {
          print("Checking if user exists: ${user.email}");
          final testUser = await getUser.call();
          print("User exists: $testUser");
          final model.User dbUser = await getUser.call();
          print("User already exists: ${dbUser.email}");
        } catch (e) {
          // 유저가 존재하지 않으면 DB에 추가
          await addUser.call(
            email: user.email!,
            username: user.displayName ?? '',
            bio: '',
            photoUrl: user.photoURL ?? '',
          );
          print("New user added: ${user.email}");
        }
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
