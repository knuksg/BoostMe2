import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String serverUrl;

  ChatService(this.serverUrl);

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('$serverUrl/chats'),
      headers: {
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
