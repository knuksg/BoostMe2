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

  Future<Map<String, dynamic>> sendMessage(
      String message, String? assistantId, String? threadId) async {
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
      body: jsonEncode({
        'message': message,
        'assistantId': assistantId,
        'threadId': threadId
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'response': data['response'],
        'function_name': data['function_name'],
        'value': data['value'],
        'assistantId': data['assistantId'],
        'threadId': data['threadId']
      };
    } else {
      throw Exception(
          'Failed to load response from server: ${response.reasonPhrase}');
    }
  }

  Future<void> saveConversation(String assistantId, String threadId) async {
    final idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('$serverUrl/chats/threadId'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'assistantId': assistantId,
        'threadId': threadId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save conversation: ${response.reasonPhrase}');
    }
  }

  Future<Map<String?, String?>> getConversation() async {
    final idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('$serverUrl/chats/threadId'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'assistantId': data['assistant_id'],
        'threadId': data['thread_id']
      };
    } else {
      throw Exception('Failed to load conversation: ${response.reasonPhrase}');
    }
  }
}
