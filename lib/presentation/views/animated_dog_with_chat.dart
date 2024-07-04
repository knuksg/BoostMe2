import 'package:boostme2/core/utils/import.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AnimatedDogWithChat extends ConsumerStatefulWidget {
  const AnimatedDogWithChat({super.key});

  @override
  _AnimatedDogWithChatState createState() => _AnimatedDogWithChatState();
}

class _AnimatedDogWithChatState extends ConsumerState<AnimatedDogWithChat>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  bool _showChat = false;
  bool _ttsEnabled = false; // TTS 활성화 여부
  final List<String> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ChatService _chatService =
      ChatService(AppConstants.apiUrl); // Node.js 서버 URL
  final bool _inputDisabled = false;
  bool _isLoading = false; // 응답을 기다리는 상태를 추가
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode(); // 입력창에 포커스를 맞추기 위한 FocusNode

  // Speech to text 관련 변수
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = '';

  // TTS 유틸리티 변수
  late TTSUtil _ttsUtil;

  @override
  void initState() {
    super.initState();
    _initializePrefs();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });

    _controller!.forward();

    _speech = stt.SpeechToText();

    // TTS 유틸리티 초기화
    _ttsUtil = TTSUtil();

    // 앱 시작 시 권한 요청
    _requestPermissions();
    _initializeWelcomeMessage();
  }

  Future<void> _initializeWelcomeMessage() async {
    final userName = ref.read(authViewModelProvider).value?.displayName ?? '유저';

    setState(() {
      _messages.add("안녕하세요, $userName님! 무엇을 도와드릴까요?");
    });
  }

  Future<void> _initializePrefs() async {
    final conversation = await _chatService.getConversation();
    setState(() {
      if (conversation['assistantId'] != null &&
          conversation['threadId'] != null) {}
    });
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) {
      // 웹에서는 별도의 권한 요청이 필요 없으므로 바로 리턴
      return;
    } else {
      await PermissionUtil.requestMicrophonePermission();
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _ttsUtil.stop(); // TTS 중지
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _showChat = !_showChat;
    });
    if (_showChat) {
      _controller!.forward();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        _focusNode.requestFocus(); // 채팅창을 열 때 입력창에 포커스
      });
    } else {
      _controller!.reverse();
    }
  }

  Future<void> _sendMessage() async {
    if (_textController.text.isNotEmpty && _textController.text.length <= 500) {
      final message = _textController.text;
      setState(() {
        _messages.add(message);
        _isLoading = true; // 응답을 기다리는 상태로 변경
      });

      try {
        final assistantIdandThreadId = await _chatService.getConversation();

        final assistantId = assistantIdandThreadId['assistantId'];
        final threadId = assistantIdandThreadId['threadId'];

        print('assistantId: $assistantId, threadId: $threadId');

        final response = await _chatService.sendMessage(
          message,
          assistantId,
          threadId,
        );

        if (response['assistantId'] != null && response['threadId'] != null) {
          await _chatService.saveConversation(
            response['assistantId'],
            response['threadId'],
          );
        }

        if (response['function_name'] != null &&
            response['function_name'] == 'create_weight' &&
            response['value'] != null) {
          final weight = double.tryParse(response['value']);
          if (weight != null) {
            final weightViewModel = ref.read(weightViewModelProvider.notifier);
            await weightViewModel.addWeight(weight);
          }
        }

        setState(() {
          _messages.add(response['response']);
          _isLoading = false; // 응답이 도착했으므로 상태 변경
          if (_ttsEnabled) {
            _ttsUtil.speak(response['response']); // TTS로 응답 읽기
          }
        });

        // 스크롤을 가장 최신 메시지로 이동
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          _focusNode.requestFocus(); // 응답이 도착했을 때 입력창에 포커스
        });
      } catch (error) {
        print('Error: $error');
        setState(() {
          _messages.add("Sorry, I couldn't process your request.");
          _isLoading = false; // 에러 발생 시 상태 변경
        });
      }
      _textController.clear();
    }
  }

  void _listen() async {
    await _requestPermissions();
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == "notListening") {
            _sendMessage(); // 음성 인식이 끝나면 메시지 전송
            setState(() => _isListening = false);
            _textController.clear(); // 텍스트 컨트롤러 초기화
          }
          print('onStatus: $val');
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _voiceInput = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _textController.text = _voiceInput;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _sendMessage(); // 음성 인식이 중지되면 메시지 전송
      _textController.clear(); // 텍스트 컨트롤러 초기화
    }
  }

  void _toggleTTS() {
    setState(() {
      _ttsEnabled = !_ttsEnabled;
    });
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
                        final isUser = index % 2 != 0;
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
                            child: Text(message),
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
                            child: TextFormField(
                              controller: _textController,
                              decoration: const InputDecoration.collapsed(
                                  hintText:
                                      'Enter your message (max 100 characters)'),
                              maxLength: 100, // 텍스트 길이 제한 추가
                              enabled: !_isLoading, // 응답을 기다리는 동안 비활성화
                              focusNode: _focusNode, // 포커스 노드 추가
                              maxLines: null, // 입력 텍스트에 따라 자동으로 높이 조절
                              onFieldSubmitted: (value) =>
                                  _sendMessage(), // 엔터키를 눌렀을 때 메시지 전송
                            ),
                          ),
                          _isListening
                              ? const DotAnimationWidget() // 점 애니메이션 위젯 사용
                              : IconButton(
                                  icon: const Icon(Icons.mic_none),
                                  onPressed: _isLoading ? null : _listen,
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
                  // TTS 활성화 버튼 추가
                  SwitchListTile(
                    title: const Text('음성으로 듣기'),
                    value: _ttsEnabled,
                    onChanged: (bool value) {
                      _toggleTTS();
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
