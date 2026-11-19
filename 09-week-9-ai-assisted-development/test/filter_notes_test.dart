import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week9_notes/features/notes/domain/entities/note.dart';
import 'package:week9_notes/features/notes/domain/usecases/filter_notes.dart';
import 'package:week9_notes/features/notes/presentation/widgets/note_search_page.dart';

void main() {
  final filterNotes = FilterNotes();
  final sampleNotes = [
    const Note(
        id: '1', title: 'Daftar Belanja Bulanan', content: 'Beras, telur'),
    const Note(id: '2', title: 'Belanja Elektronik', content: 'Kabel charger'),
    const Note(id: '3', title: 'Catatan Kuliah', content: 'Clean Architecture'),
  ];

  test('filter abaikan huruf besar/kecil dan spasi berlebih', () {
    final result = filterNotes(sampleNotes, '  BELANJA ');
    expect(result, hasLength(2));
  });

  test('query tak cocok kembalikan list kosong (empty state)', () {
    final result = filterNotes(sampleNotes, 'zzz-tak-ada');
    expect(result, isEmpty);
  });

  test('query kosong kembalikan semua catatan', () {
    final result = filterNotes(sampleNotes, '');
    expect(result, hasLength(3));
  });

  testWidgets('menampilkan pesan empty state saat query tidak ditemukan',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: NoteSearchPage(initialNotes: sampleNotes)),
    );

    await tester.enterText(find.byType(TextField), 'zzz-tak-ada');
    await tester.pump();

    expect(find.text('Catatan tidak ditemukan'), findsOneWidget);
  });
}
