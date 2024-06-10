import 'package:boostme2/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authViewModel.signInWithGoogle();
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
