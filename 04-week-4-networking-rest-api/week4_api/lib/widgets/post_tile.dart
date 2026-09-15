import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  const PostTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () {
        // Melempar id dan data post utuh ke halaman detail
        context.push('/post/${post.id}', extra: post);
      },
    );
  }
}