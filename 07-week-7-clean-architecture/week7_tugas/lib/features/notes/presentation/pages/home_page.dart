import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Campus Notify')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/pengumuman/123'),
          child: const Text('Buka Detail Pengumuman #123'),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengumuman #$id')),
      body: Center(
        child: Text('Isi Detail Pengumuman ID: $id', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}