import '../entities/note.dart';

class FilterNotes {
  List<Note> call(List<Note> notes, String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return notes;

    return notes
        .where((note) => note.title.toLowerCase().contains(cleanQuery))
        .toList();
  }
}
