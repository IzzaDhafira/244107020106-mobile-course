import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week12_testing/note_app.dart';

class FakeSuccessRepository implements NoteRepository {
  final List<Note> storage = [
    const Note(id: '1', title: 'Belajar Unit Test'),
  ];

  @override
  Future<List<Note>> fetchNotes() async => List.from(storage);

  @override
  Future<void> saveNote(Note note) async => storage.add(note);
}

class FakeErrorRepository implements NoteRepository {
  @override
  Future<List<Note>> fetchNotes() async {
    throw Exception('Database connection failed');
  }

  @override
  Future<void> saveNote(Note note) async {
    throw Exception('Write error');
  }
}

void main() {
  group('Unit Test - Validasi & Aturan Bisnis NoteService', () {
    late NoteService service;

    setUp(() {
      service = NoteService(FakeSuccessRepository());
    });

    test('mengembalikan pesan error jika judul kosong atau spasi saja', () {
      expect(service.validateTitle('   '), 'Judul catatan tidak boleh kosong');
    });

    test('mengembalikan pesan error untuk kasus tepi (< 3 karakter)', () {
      expect(service.validateTitle('ab'), 'Judul minimal 3 karakter');
    });

    test('berhasil menambahkan catatan jika judul valid', () async {
      final created = await service.addNote('  Rapat Proyek  ');
      expect(created.title, 'Rapat Proyek');
      final all = await service.getAllNotes();
      expect(all, hasLength(2));
    });
  });

  group('Dependency Test - Fake Repository Sukses & Error', () {
    test('FakeSuccessRepository mengembalikan daftar catatan awal', () async {
      final service = NoteService(FakeSuccessRepository());
      final notes = await service.getAllNotes();
      expect(notes.first.title, 'Belajar Unit Test');
    });

    test('FakeErrorRepository melempar exception saat gagal mengambil data', () {
      final service = NoteService(FakeErrorRepository());
      expect(() => service.getAllNotes(), throwsException);
    });
  });

  group('Widget Test - Interaksi UI NoteManagerPage', () {
    testWidgets('menampilkan tampilan awal kosong dengan benar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: NoteManagerPage(repository: InMemoryNoteRepository())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Daftar Tugas & Catatan'), findsOneWidget);
      expect(find.text('Belum ada catatan'), findsOneWidget);
    });

    testWidgets('menampilkan pesan error saat input tidak valid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: NoteManagerPage(repository: InMemoryNoteRepository())),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('note_input_field')), 'a');
      await tester.tap(find.byKey(const Key('add_note_button')));
      await tester.pump();

      expect(find.text('Judul minimal 3 karakter'), findsOneWidget);
    });

    testWidgets('menambahkan item baru ke daftar saat input valid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: NoteManagerPage(repository: InMemoryNoteRepository())),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('note_input_field')),
        'Selesaikan Modul Week 12',
      );
      await tester.tap(find.byKey(const Key('add_note_button')));
      await tester.pumpAndSettle();

      expect(find.text('Selesaikan Modul Week 12'), findsOneWidget);
      expect(find.text('Belum ada catatan'), findsNothing);
    });

    testWidgets('menampilkan error UI ketika repository gagal memuat data',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: NoteManagerPage(repository: FakeErrorRepository())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Gagal memuat data catatan'), findsOneWidget);
    });
  });

  group('End-to-End Flow Test - Alur Utama Pengguna', () {
    testWidgets('alur lengkap: validasi input gagal lalu tambah catatan sukses',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: NoteManagerPage(repository: InMemoryNoteRepository())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Belum ada catatan'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('note_input_field')), 'Hi');
      await tester.tap(find.byKey(const Key('add_note_button')));
      await tester.pumpAndSettle();
      expect(find.text('Judul minimal 3 karakter'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('note_input_field')),
        'Presentasi Akhir Proyek',
      );
      await tester.tap(find.byKey(const Key('add_note_button')));
      await tester.pumpAndSettle();

      expect(find.text('Presentasi Akhir Proyek'), findsOneWidget);
    });
  });
}