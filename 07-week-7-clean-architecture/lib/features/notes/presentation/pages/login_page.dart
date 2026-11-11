import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(secureStorageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await storage.write(key: 'token', value: 'secret_token');
            } catch (e) {
              debugPrint('Storage error (diabaikan untuk mock): $e');
            }
            
            ref.read(authProvider.notifier).setLoggedIn(true);
          },
          child: const Text('Mock Login'),
        ),
      ),
    );
  }
}