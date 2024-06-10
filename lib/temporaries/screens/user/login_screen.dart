import 'package:boostme2/temporaries/providers/user_provider.dart';
import 'package:boostme2/temporaries/resources/auth_methods.dart';
import 'package:boostme2/temporaries/utils/responsive/mobile_screen_layout.dart';
import 'package:boostme2/temporaries/utils/responsive/responsive_layout_screen.dart';
import 'package:boostme2/temporaries/utils/responsive/web_screen_layout.dart';
import 'package:boostme2/temporaries/screens/user/signup_screen.dart';
import 'package:boostme2/temporaries/utils/colors.dart';
import 'package:boostme2/temporaries/utils/global_variables.dart';
import 'package:boostme2/temporaries/utils/utils.dart';
import 'package:boostme2/temporaries/widgets/text_field_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    // Null check
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      String res =
          await AuthMethods.loginUser(email: email, password: password);
      if (res == 'success') {
        await UserProvider().refreshUser();
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                ),
              ),
              (route) => false);
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print("Login failed: $res");
        showSnackBar(context, res);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Login failed with exception: $e");
      showSnackBar(context, e.toString());
    }
  }

  void _loginUserWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String res = await AuthMethods.signInWithGoogle();
      print("Login result: $res");
      if (res == 'success') {
        await UserProvider().refreshUser();
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                ),
              ),
              (route) => false);
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print("Login failed: $res");
        showSnackBar(context, res);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Login failed with exception: $e");
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Image.asset(
                'assets/images/logo.png',
                color: Colors.blueAccent,
                height: 200,
              ),
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  _loginUser();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  child: !_isLoading
                      ? const Text(
                          'Log in',
                        )
                      : const CircularProgressIndicator(
                          color: primaryColor,
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Dont have an account?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Signup.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  'or continue with',
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SignInButton(
                Buttons.google,
                onPressed: () {
                  _loginUserWithGoogle();
                },
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
