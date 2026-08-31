import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Profil Mahasiswa')),
        body: const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.school, size: 72),
              Text('Izza Dhafira Fanani', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('NIM: 244107020106', style: TextStyle(fontSize: 18)), 
              Text('Fokus: UI/UX Design & Data Analysis', style: TextStyle(fontSize: 16, color: Colors.blueGrey)), 
              SizedBox(height: 16),
              Text('Pemrograman Mobile - Minggu 1'),
            ],
          ),
        ),
      ),
    );
  }
}