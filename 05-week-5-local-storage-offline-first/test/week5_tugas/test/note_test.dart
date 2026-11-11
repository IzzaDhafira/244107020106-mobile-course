import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week5_tugas/data/local/note.dart';
import 'package:week5_tugas/data/repositories/note_repository.dart';
import 'package:week5_tugas/pages/notes_page.dart';

class FakeNoteRepository extends NoteRepository {
  FakeNoteRepository({this.items = const [], this.throwError = false}) : super(openDb: () => throw UnimplementedError());
  final List<Note> items;
  final bool throwError;

  @override
  Future<List<Note>> fetchNotes() async {
    if (throwError) throw Exception('db locked (simulasi)');
    return items;
  }
  @override
  Future<int> countDirty() => Future.value(items.where((n) => n.dirty).length);
}

void main() {
  test('fromMap aman terhadap field yang hilang', () {
    final note = Note.fromMap({'title': 'Belanja'});
    expect(note.title, 'Belanja');
    expect(note.dirty, isFalse);
  });

  test('provider sukses dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [noteRepositoryProvider.overrideWithValue(FakeNoteRepository(items: [Note(title: 'Tes', updatedAt: DateTime.now())]))],
    );
    addTearDown(container.dispose);
    final notes = await container.read(notesProvider.future);
    expect(notes.length, 1);
    expect(notes.first.title, 'Tes');
  });

  test('provider error dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [
        noteRepositoryProvider.overrideWithValue(
          FakeNoteRepository(throwError: true),
        ),
      ],
    );
    addTearDown(container.dispose);
    final repo = container.read(noteRepositoryProvider);
    
    await expectLater(
      repo.fetchNotes(),
      throwsA(isA<Exception>()),
    );
  });
}