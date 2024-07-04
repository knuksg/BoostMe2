import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    if (status.isGranted) {
      print('Microphone permission granted');
    } else {
      print('Microphone permission denied');
      throw Exception('Microphone permission denied');
    }
  }
}
