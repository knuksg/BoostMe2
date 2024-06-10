import 'package:boostme2/temporaries/utils/responsive/mobile_screen_layout.dart';
import 'package:boostme2/temporaries/utils/responsive/responsive_layout_screen.dart';
import 'package:boostme2/temporaries/utils/responsive/web_screen_layout.dart';
import 'package:boostme2/temporaries/screens/user/login_screen.dart';
import 'package:boostme2/temporaries/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:provider/provider.dart';
import 'package:boostme2/firebase_options.dart';
import 'package:boostme2/temporaries/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  // print('Loaded API_URL: ${dotenv.env['API_URL']}'); // 환경 변수가 올바르게 로드되었는지 확인

  // initialise app based on platform- web or mobile
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BoostMe',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
