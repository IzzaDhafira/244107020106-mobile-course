import '../entities/note.dart';

class FilterNotes {
  final Map<String, List<Note>> _cache = {};

  List<Note> call(List<Note> notes, String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return notes;

    if (_cache.containsKey(cleanQuery)) {
      return _cache[cleanQuery]!;
    }

    final filtered = notes
        .where((note) => note.title.toLowerCase().contains(cleanQuery))
        .toList();
    _cache[cleanQuery] = filtered;
    return filtered;
  }

  void clearCache() => _cache.clear();
}