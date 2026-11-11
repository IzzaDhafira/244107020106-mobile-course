import 'package:flutter/material.dart';
import '../data/models/post.dart';

class PostDetailPage extends StatelessWidget {
  final int id;
  final Post? post;

  const PostDetailPage({super.key, required this.id, this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Post #$id')),
      body: post != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post!.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(post!.body, style: const TextStyle(fontSize: 16)),
                ],
              ),
            )
          : const Center(child: Text('Data tidak tersedia...')),
    );
  }
}