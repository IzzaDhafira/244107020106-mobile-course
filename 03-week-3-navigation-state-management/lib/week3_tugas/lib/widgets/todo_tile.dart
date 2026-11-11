import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';

class TodoTile extends ConsumerWidget {
  final Todo todo;
  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) => ref.read(todoListProvider.notifier).toggle(todo.title),
      ),
    );
  }
}