import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIClient {
  final String apiKey;
  final List<Map<String, String>> messages = [];

  OpenAIClient(this.apiKey) {
    messages.add({
      'role': 'system',
      'content':
          'You are a helpful assistant. When the user says "오늘 체중 {weight}키로 기록해줘", respond with {"function_name": "create_weight", "value": "{weight}"}.'
    });
  }

  Future<String> sendMessage(String message) async {
    messages.add({'role': 'user', 'content': message});

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': messages,
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final chatResponse = data['choices'][0]['message']['content'].trim();
      messages.add({'role': 'assistant', 'content': chatResponse});
      return chatResponse;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(
          'Failed to load response from OpenAI: ${data['error']['message']}');
    }
  }
}
