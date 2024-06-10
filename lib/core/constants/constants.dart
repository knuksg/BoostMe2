import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appTitle = 'Flutter Clean Architecture';
  static const String apiUrl = 'https://flyingstone.me/boostme/api';
  // static const String apiUrl = 'http://localhost:4000';
  static String apiKey = dotenv.env['OPENAI_API_KEY']!;
}
