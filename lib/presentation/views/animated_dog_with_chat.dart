import 'dart:convert';

import 'package:boostme2/core/constants/constants.dart';
import 'package:boostme2/core/utils/chat_service.dart';
import 'package:boostme2/presentation/viewmodels/weight_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedDogWithChat extends ConsumerStatefulWidget {
  const AnimatedDogWithChat({super.key});

  @override
  _AnimatedDogWithChatState createState() => _AnimatedDogWithChatState();
}

class _AnimatedDogWithChatState extends ConsumerState<AnimatedDogWithChat>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  bool _showChat = false;
  final List<Map<String, String>> _messages = [
    {"role": "assistant", "content": "안녕하세요! 무엇을 도와드릴까요?"}
  ];
  final TextEditingController _textController = TextEditingController();
  final ChatService _chatService =
      ChatService(AppConstants.apiUrl); // Node.js 서버 URL
  bool _inputDisabled = false;
  bool _isLoading = false; // 응답을 기다리는 상태를 추가
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });

    _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _showChat = !_showChat;
    });
    if (_showChat) {
      _controller!.forward();
      // 스크롤을 가장 최신 메시지로 이동
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _controller!.reverse();
    }
  }

  void _resetChat() {
    setState(() {
      _messages.clear();
      _messages.add({"role": "assistant", "content": "안녕하세요! 무엇을 도와드릴까요?"});
      _inputDisabled = false;
    });
  }

  Future<void> _sendMessage() async {
    if (_textController.text.isNotEmpty && _textController.text.length <= 500) {
      setState(() {
        _messages.add({"role": "user", "content": _textController.text});
        _isLoading = true; // 응답을 기다리는 상태로 변경
        if (_messages.where((message) => message['role'] == 'user').length >=
            5) {
          _inputDisabled = true;
        }
      });

      try {
        final response = await _chatService.sendMessage(_messages);

        // 응답이 JSON 형식인 경우 처리
        try {
          final jsonResponse = jsonDecode(response);
          if (jsonResponse['function_name'] == 'create_weight' &&
              jsonResponse['value'] != null) {
            final weight = double.tryParse(jsonResponse['value']);
            if (weight != null) {
              final weightViewModel =
                  ref.read(weightViewModelProvider.notifier);
              await weightViewModel.addWeight(weight);
            }
            setState(() {
              _messages.add(
                  {"role": "assistant", "content": jsonResponse['response']});
              _isLoading = false; // 응답이 도착했으므로 상태 변경
            });
          } else {
            setState(() {
              _messages.add({"role": "assistant", "content": response});
              _isLoading = false; // 응답이 도착했으므로 상태 변경
            });
          }
        } catch (e) {
          setState(() {
            // 응답이 JSON 형식이 아닌 경우 처리
            _messages.add({"role": "assistant", "content": response});
            _isLoading = false; // 응답이 도착했으므로 상태 변경
          });
        }

        // 스크롤을 가장 최신 메시지로 이동
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } catch (error) {
        setState(() {
          _messages.add({
            "role": "assistant",
            "content": "Sorry, I couldn't process your request."
          });
          _isLoading = false; // 에러 발생 시 상태 변경
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
                      controller: _scrollController,
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
                              maxLength: 500, // 텍스트 길이 제한 추가
                              enabled: !_isLoading, // 응답을 기다리는 동안 비활성화
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _isLoading
                                ? null
                                : _sendMessage, // 응답을 기다리는 동안 비활성화
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
