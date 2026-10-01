import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';
import '../data/sync.dart';
import '../widgets/note_tile.dart';
import 'settings_page.dart';

final noteRepositoryProvider = Provider((ref) => NoteRepository());
final forceOfflineProvider = NotifierProvider<ForceOfflineNotifier, bool>(ForceOfflineNotifier.new);

class ForceOfflineNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void setOffline(bool value) => state = value;
}

final notesProvider = FutureProvider.autoDispose<List<Note>>((ref) async => ref.watch(noteRepositoryProvider).fetchNotes());
final dirtyCountProvider = FutureProvider.autoDispose<int>((ref) async => ref.watch(noteRepositoryProvider).countDirty());

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});
  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  @override
  void initState() {
    super.initState();
    // Catat waktu terakhir dibuka ke SharedPreferences saat halaman utama dirender
    Future.microtask(() => ref.read(prefsRepositoryProvider).markOpenedNow());
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);
    final dirtyCountAsync = ref.watch(dirtyCountProvider);
    final isOffline = ref.watch(forceOfflineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Notes'),
        actions: [
          Row(
            children: [
              Text(isOffline ? 'Offline' : 'Online', style: const TextStyle(fontSize: 12)),
              Switch(value: isOffline, onChanged: (val) => ref.read(forceOfflineProvider.notifier).setOffline(val)),
            ],
          ),
          Center(
            child: dirtyCountAsync.whenOrNull(
              data: (count) => count > 0
                  ? Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text('Dirty: $count', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))
                  : const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.cloud_done)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: isOffline ? null : () async {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menyinkronkan data...')));
              await syncNotes(ref.read(noteRepositoryProvider));
              ref.invalidate(notesProvider);
              ref.invalidate(dirtyCountProvider);
            },
          ),
          IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()))),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) return const Center(child: Text('Belum ada catatan.'));
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return NoteTile(
                note: notes[index],
                onDelete: () async {
                  await ref.read(noteRepositoryProvider).deleteNote(notes[index].id!);
                  ref.invalidate(notesProvider);
                  ref.invalidate(dirtyCountProvider);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(noteRepositoryProvider).addNote(title: 'Catatan Baru ${DateTime.now().minute}:${DateTime.now().second}');
          ref.invalidate(notesProvider);
          ref.invalidate(dirtyCountProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}