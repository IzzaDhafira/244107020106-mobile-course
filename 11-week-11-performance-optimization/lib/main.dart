import 'package:flutter/material.dart';
import 'features/notes/domain/entities/note.dart';
import 'features/notes/presentation/widgets/optimized_notes_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final List<Note> _sampleNotes = List.generate(
    500,
    (i) => Note(
      id: '$i',
      title: 'Catatan Proyek #$i',
      content: 'Ringkasan materi perkuliahan dan tugas minggu ke-${(i % 12) + 1}',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optimized Notes App',
      theme: ThemeData(useMaterial3: true),
      home: OptimizedNotesPage(notes: _sampleNotes),
    );
  }
}