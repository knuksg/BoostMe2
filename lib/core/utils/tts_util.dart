import 'package:flutter_tts/flutter_tts.dart';

class TTSUtil {
  late FlutterTts _flutterTts;

  TTSUtil() {
    _flutterTts = FlutterTts();
    _initializeTTS();
  }

  void _initializeTTS() async {
    await _flutterTts.setLanguage("ko-KR");
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
