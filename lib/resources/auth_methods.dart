import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:boostme2/resources/storage_method.dart';
import 'package:boostme2/models/user.dart' as model;

class AuthMethods {
  final Dio _dio = Dio();
  final String baseUrl = "https://flyingstone.me/boostme";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
        );

        await createUser(user);

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  static Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isEmpty || password.isEmpty) {
        print("Email or password is empty");
        return "Please enter all the fields";
      } else {
        // logging in user with email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      }
    } catch (err) {
      print("Exception: $err"); // Log the exception to understand the error
      return "Unknown error occurred: $err";
    }
    return res;
  }

  // 범용 로그아웃 함수
  static Future<String> signOut() async {
    try {
      // 파이어베이스 현재 로그인한 유저 정보 가져오기
      User? currentUser = FirebaseAuth.instance.currentUser;
      print('Current user: $currentUser');

      if (currentUser != null) {
        // 파이어베이스에서 사용자가 사용하는 로그인 방식 확인
        List<UserInfo> providerData = currentUser.providerData;
        print('Provider data: $providerData');

        // // 각각의 로그인 방식에 대한 로그아웃 처리
        // for (var userInfo in providerData) {
        //   switch (userInfo.providerId) {
        //     case 'google.com':
        //       await FirebaseAuth.instance.
        //       break;

        //     // 추가 가능한 다른 소셜 로그인 처리
        //     default:
        //       break;
        //   }
        // }
      }

      // 파이어베이스 로그아웃 실행
      await FirebaseAuth.instance.signOut();
      print('Signed out successfully');
      return "All users signed out successfully";
    } catch (e) {
      return "Error signing out: $e";
    }
  }

  static Future<String> signInWithGoogle() async {
    String res = "Some error occurred";
    late UserCredential userCredential;
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          print("Sign in failed or cancelled by user.");
          return "Sign in failed or cancelled by user.";
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // 파이어베이스에 사용자 등록
        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
      }

      User? user = userCredential.user;

      if (user != null) {
        // 신규 유저인지 확인
        if (userCredential.additionalUserInfo!.isNewUser) {
          // 신규 유저 데이터베이스에 등록
          String photoUrl = user.photoURL ??
              "gs://boostme-147c6.appspot.com/profilePics/default.jpg";
          model.User newUser = model.User(
            username: user.displayName ?? "NoName",
            uid: user.uid,
            photoUrl: photoUrl,
            email: user.email ?? "NoEmail",
            bio: "New user from Google", // 예시로 기본 bio 설정
          );
          await createUser(newUser);
        }
        res = "success";
      }
    } catch (err) {
      print("Exception during Google sign in: $err");
      return "Unknown error occurred: $err";
    }
    return res;
  }

  static Future<List<model.User>> fetchUsers() async {
    Dio dio = Dio();
    const String baseUrl = "https://flyingstone.me/boostme";
    try {
      final response = await dio.get('$baseUrl/api/users');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<model.User> users =
            data.map((userJson) => model.User.fromJson(userJson)).toList();
        return users;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  static Future<model.User> fetchUserById(String id) async {
    Dio dio = Dio();
    const String baseUrl = "https://flyingstone.me/boostme";
    try {
      final response = await dio.get('$baseUrl/api/users/$id');
      if (response.statusCode == 200) {
        return model.User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load user: $e');
    }
  }

  static Future<void> createUser(model.User user) async {
    Dio dio = Dio();
    const String baseUrl = "https://flyingstone.me/boostme";
    try {
      final response = await dio.post(
        '$baseUrl/api/users',
        data: user.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  static Future<void> updateUser(String id, model.User user) async {
    Dio dio = Dio();
    const String baseUrl = "https://flyingstone.me/boostme";
    try {
      final response = await dio.put(
        '$baseUrl/api/users/$id',
        data: user.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  static Future<void> deleteUser(String id) async {
    Dio dio = Dio();
    const String baseUrl = "https://flyingstone.me/boostme";
    try {
      final response = await dio.delete('$baseUrl/api/users/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
