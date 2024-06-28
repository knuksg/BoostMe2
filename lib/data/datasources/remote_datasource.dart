import 'package:boostme2/core/constants/constants.dart';
import 'package:boostme2/data/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class RemoteDataSource {
  final http.Client client;

  RemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  Future<Map<String, dynamic>> getUser() async {
    final idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await client.get(
      Uri.parse('${AppConstants.apiUrl}/users'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      print("Response at remote datasource: ${response.body}");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<void> addUser({
    required String email,
    required String username,
    required String bio,
    required String photoUrl,
  }) async {
    final idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await client.post(
      Uri.parse('${AppConstants.apiUrl}/users'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'username': username,
        'bio': bio,
        'photo_url': photoUrl,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add user');
    }
  }

  Future<void> updateUser({
    required String email,
    required String username,
    required String bio,
    required String photoUrl,
  }) async {
    final idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await client.put(
      Uri.parse('${AppConstants.apiUrl}/users'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'username': username,
        'bio': bio,
        'photo_url': photoUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser() async {
    final idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await client.delete(
      Uri.parse('${AppConstants.apiUrl}/users'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  Future<void> addWeight(double weight) async {
    final idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final date =
        DateTime.now().toUtc().toIso8601String().split('T').first; // 날짜만 추출

    final response = await client.post(
      Uri.parse('${AppConstants.apiUrl}/weights'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'date': date,
        'weight': weight,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add weight');
    }
  }

  Future<List<Map<String, dynamic>>> getWeights() async {
    final idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await client.get(
      Uri.parse('${AppConstants.apiUrl}/weights'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load weights');
    }
  }

  Future<List<ProductModel>> getProducts() async {
    final response =
        await http.get(Uri.parse('${AppConstants.apiUrl}/products'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ProductModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await http
        .get(Uri.parse('${AppConstants.apiUrl}/products/category/$category'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      final List<ProductModel> products =
          jsonResponse.map((data) => ProductModel.fromJson(data)).toList();
      return products;
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  Future<List<ProductModel>> getPopularProducts() async {
    final response =
        await http.get(Uri.parse('${AppConstants.apiUrl}/products/sales'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ProductModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load popular products');
    }
  }
}
