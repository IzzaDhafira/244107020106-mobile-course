import 'package:flutter/material.dart';
import '../data/local/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;

  const NoteTile({
    super.key,
    required this.note,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text('Diperbarui: ${note.updatedAt.toString().substring(0, 16)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (note.dirty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Belum tersinkron',
                style: TextStyle(fontSize: 10, color: Colors.orange),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}