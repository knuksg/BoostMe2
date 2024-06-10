import 'dart:io';

import 'package:boostme2/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/views/login_screen.dart';
import 'presentation/views/home_screen.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 절대 경로 사용
  String envFilePath =
      '/home/talk_flyingstone/flutterWork/boostme_flutter/.env';
  if (File(envFilePath).existsSync()) {
    print('.env file exists at $envFilePath');

    // 파일 내용 출력
    print('Contents of .env file:');
    File(envFilePath).readAsLinesSync().forEach((line) {
      print(line);
    });
  } else {
    print('.env file does not exist at $envFilePath');
  }

  await dotenv.load(fileName: envFilePath);

  // 환경 변수가 제대로 불러와졌는지 테스트
  String? openaiApiKey = dotenv.env['OPENAI_API_KEY'];
  print('OPENAI_API_KEY: $openaiApiKey');

  dotenv.env.forEach((key, value) {
    print('$key: $value');
  });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.signOut();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (user) => user != null ? const HomeScreen() : const LoginScreen(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) =>
            Scaffold(body: Center(child: Text('Error: $error'))),
      ),
    );
  }
}
