import 'package:boostme2/models/user.dart' as model;
import 'package:boostme2/resources/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthMethods _authMethods = AuthMethods();

  model.User? get getUser => _user;

  Future<void> refreshUser() async {
    if (_auth.currentUser != null) {
      model.User user =
          await _authMethods.fetchUserById(_auth.currentUser!.uid);
      _user = user;
      notifyListeners();
    } else {
      print("No current user found");
    }
  }
}
