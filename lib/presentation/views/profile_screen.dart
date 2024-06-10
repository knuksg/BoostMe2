import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authViewModelProvider.notifier);
    final user = authViewModel.currentUser;

    return Center(
      child: user == null
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Email: ${user.email}'),
                Text('Username: ${user.displayName}'),
                user.photoURL != null
                    ? Image.network(user.photoURL!)
                    : Container(),
              ],
            ),
    );
  }
}
