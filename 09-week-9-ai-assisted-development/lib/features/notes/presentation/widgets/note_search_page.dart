import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/filter_notes.dart';

class NoteSearchPage extends StatefulWidget {
  final List<Note> initialNotes;
  const NoteSearchPage({super.key, required this.initialNotes});

  @override
  State<NoteSearchPage> createState() => _NoteSearchPageState();
}

class _NoteSearchPageState extends State<NoteSearchPage> {
  final _filterNotes = FilterNotes();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = _filterNotes(widget.initialNotes, _query);

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Catatan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari judul catatan...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('Catatan tidak ditemukan'))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (_, i) => ListTile(
                      title: Text(results[i].title),
                      subtitle: Text(results[i].content),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
