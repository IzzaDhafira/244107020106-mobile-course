import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Membaca status auth untuk menampilkan loading atau error
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login Campus Notify')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'contoh@campus.id',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password (min. 6 karakter)'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            
            // Menampilkan pesan error jika login gagal
            if (authState.hasError)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  authState.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              
            // Menampilkan indikator loading saat proses login berjalan
            authState.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      // Memanggil fungsi login dari provider
                      ref.read(authStateProvider.notifier).login(email, password);
                    },
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}