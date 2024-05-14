import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:boostme2/resources/storage_method.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:boostme2/models/user.dart' as model;

class AuthMethods {
  final Dio _dio = Dio();
  final String baseUrl = dotenv.env['API_URL']!;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
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
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
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

  void printTest() {
    print("AuthMethods instance is working");
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    print("🔓 Attempting to sign in with email and password");
    String res = "Some error Occurred";
    try {
      if (email.isEmpty || password.isEmpty) {
        print("Email or password is empty");
        return "Please enter all the fields";
      } else {
        print("Attempting to sign in with email and password");
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
        print("Login successful");
      }
    } catch (err) {
      print("Exception: $err"); // Log the exception to understand the error
      return "Unknown error occurred: $err";
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<List<model.User>> fetchUsers() async {
    try {
      final response = await _dio.get('$baseUrl/api/users');
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

  Future<model.User> fetchUserById(String id) async {
    try {
      print("🔓 Fetching user with ID: $id");
      final response = await _dio.get('$baseUrl/api/users/$id');
      print(response.data);
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

  Future<void> createUser(model.User user) async {
    try {
      final response = await _dio.post(
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

  Future<void> updateUser(String id, model.User user) async {
    try {
      final response = await _dio.put(
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

  Future<void> deleteUser(String id) async {
    try {
      final response = await _dio.delete('$baseUrl/api/users/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
