import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/filter_notes.dart';

class OptimizedNotesPage extends StatefulWidget {
  final List<Note> notes;
  const OptimizedNotesPage({super.key, required this.notes});

  @override
  State<OptimizedNotesPage> createState() => _OptimizedNotesPageState();
}

class _OptimizedNotesPageState extends State<OptimizedNotesPage> {
  final _searchController = TextEditingController();
  final _filterNotes = FilterNotes();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filterNotes(widget.notes, _query);

    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Teroptimasi')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari judul catatan...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('Catatan tidak ditemukan'))
                : ListView.builder(
                    itemCount: results.length,
                    itemExtent: 76,
                    itemBuilder: (_, index) {
                      return RepaintBoundary(
                        child: _NoteCardTile(note: results[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NoteCardTile extends StatelessWidget {
  final Note note;
  const _NoteCardTile({required this.note});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.note_alt_outlined),
      title: Text(
        note.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        note.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}