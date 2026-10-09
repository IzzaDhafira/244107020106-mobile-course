import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  final String id;
  
  const AnnouncementPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengumuman'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.campaign, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Membaca pengumuman dengan ID:',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              id,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}