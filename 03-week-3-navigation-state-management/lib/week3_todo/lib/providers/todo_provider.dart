import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  final String title;
  final bool isCompleted;
  Todo({required this.title, this.isCompleted = false});
  
  Todo toggle() => Todo(title: title, isCompleted: !isCompleted);
}

class TodoListNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [];

  void add(String title) {
    state = [...state, Todo(title: title)];
  }

  void toggle(String title) {
    state = [
      for (final todo in state)
        if (todo.title == title) todo.toggle() else todo
    ];
  }
}

final todoListProvider = NotifierProvider<TodoListNotifier, List<Todo>>(
  TodoListNotifier.new,
);

// REFACTORING: Provider turunan untuk filter tugas yang belum selesai
final uncompletedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoListProvider);
  return todos.where((todo) => !todo.isCompleted).toList();
});