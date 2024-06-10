import 'package:boostme2/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:boostme2/core/utils/openai_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AnimatedDogWithChat extends StatefulWidget {
  const AnimatedDogWithChat({super.key});

  @override
  _AnimatedDogWithChatState createState() => _AnimatedDogWithChatState();
}

class _AnimatedDogWithChatState extends State<AnimatedDogWithChat>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  bool _showChat = false;
  final List<Map<String, String>> _messages = [];
  final TextEditingController _textController = TextEditingController();
  OpenAIClient? _openAIClient;
  bool _inputDisabled = false;

  @override
  void initState() {
    super.initState();
    print("initState() called");

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });

    _controller!.forward();

    // 초반 메시지 추가
    _messages.add({"role": "assistant", "content": "안녕하세요! 어떻게 도와드릴까요?"});

    // OpenAI API 클라이언트 초기화
    try {
      final openaiApiKey = dotenv.env['OPENAI_API_KEY'];
      if (openaiApiKey != null) {
        _openAIClient = OpenAIClient(openaiApiKey);
      } else {
        throw Exception("OPENAI_API_KEY not found");
      }
    } catch (e) {
      print('Error initializing OpenAIClient: $e');
      _messages.add({
        "role": "assistant",
        "content": "OpenAI API 키를 찾을 수 없습니다. 환경 변수가 올바르게 설정되었는지 확인하세요."
      });
    }

    // .env 파일의 모든 키와 값을 출력
    print('Loaded environment variables:');
    dotenv.env.forEach((key, value) {
      print('$key: $value');
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _showChat = !_showChat;
    });
  }

  void _resetChat() {
    setState(() {
      _messages.clear();
      _inputDisabled = false;
    });
    _messages.add({"role": "assistant", "content": "안녕하세요! 어떻게 도와드릴까요?"});
  }

  Future<void> _sendMessage() async {
    if (_textController.text.isNotEmpty && _textController.text.length <= 500) {
      setState(() {
        _messages.add({"role": "user", "content": _textController.text});
        if (_messages.where((message) => message['role'] == 'user').length >=
            5) {
          _inputDisabled = true;
        }
      });

      if (_openAIClient != null) {
        try {
          final response =
              await _openAIClient!.sendMessage(_textController.text);
          setState(() {
            _messages.add({"role": "assistant", "content": response});
          });
        } catch (error) {
          setState(() {
            _messages.add({
              "role": "assistant",
              "content": "Sorry, I couldn't process your request."
            });
          });
        }
      } else {
        setState(() {
          _messages.add({
            "role": "assistant",
            "content": "OpenAI API 클라이언트가 초기화되지 않았습니다."
          });
        });
      }

      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 76,
          right: 16,
          child: GestureDetector(
            onTap: _toggleChat,
            child: Opacity(
              opacity: _animation!.value,
              child: Image.asset('assets/images/dog.gif', height: 100),
            ),
          ),
        ),
        if (_showChat)
          Positioned(
            bottom: 200,
            right: 16,
            left: 16,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Chat with Dog',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _toggleChat,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isUser = message['role'] == 'user';
                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color:
                                  isUser ? Colors.green[100] : Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(message['content']!),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  if (!_inputDisabled)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: const InputDecoration.collapsed(
                                  hintText:
                                      'Enter your message (max 500 characters)'),
                              maxLength: 500,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _sendMessage,
                          ),
                        ],
                      ),
                    ),
                  if (_inputDisabled)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _resetChat,
                        child: const Text('Reset Chat'),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
