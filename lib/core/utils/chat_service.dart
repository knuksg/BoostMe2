import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final String serverUrl;

  ChatService(this.serverUrl);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  Future<String> sendMessage(String message) async {
    final idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('User not authenticated');
    }
    final response = await http.post(
      Uri.parse('$serverUrl/chats'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'];
    } else {
      throw Exception(
          'Failed to load response from server: ${response.reasonPhrase}');
    }
  }
}
