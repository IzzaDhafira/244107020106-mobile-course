import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';
import 'settings_page.dart';
import '../widgets/note_tile.dart';

// --- PROVIDER ---
final noteRepositoryProvider = Provider((ref) => NoteRepository());

// StateProvider untuk toggle forceOffline (Simulasi Praktikum 3)
final forceOfflineProvider = NotifierProvider<ForceOfflineNotifier, bool>(ForceOfflineNotifier.new);

class ForceOfflineNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setOffline(bool value) {
    state = value;
  }
}

final notesProvider = FutureProvider.autoDispose<List<Note>>((ref) async {
  return ref.watch(noteRepositoryProvider).fetchNotes();
});

final dirtyCountProvider = FutureProvider.autoDispose<int>((ref) async {
  return ref.watch(noteRepositoryProvider).countDirty();
});

// --- FUNGSI SINKRONISASI PRAKTIKUM 3 ---
// Fungsi ini mensimulasikan server dengan delay dan mengembalikan jumlah data yang disinkronisasi[cite: 12].
Future<int> syncNotes(NoteRepository repo) async {
  final dirtyCount = await repo.countDirty();
  if (dirtyCount == 0) return 0;
  
  // Simulasi upload ke server[cite: 12]
  await Future.delayed(const Duration(seconds: 1));
  await repo.markAllSynced();
  
  return dirtyCount;
}

// --- TAMPILAN UI ---
class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    final dirtyCountAsync = ref.watch(dirtyCountProvider);
    
    // Membaca status offline dari provider
    final isOffline = ref.watch(forceOfflineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Notes'),
        actions: [
          // Toggle Force Offline untuk mempermudah testing demo tanpa mematikan Wi-Fi kelas
          Row(
            children: [
              Text(isOffline ? 'Offline' : 'Online', style: const TextStyle(fontSize: 12)),
              Switch(
                value: isOffline,
                onChanged: (val) {
                  ref.read(forceOfflineProvider.notifier).setOffline(val);
                },
              ),
            ],
          ),
          
          // Indikator Badge Dirty
          Center(
            child: dirtyCountAsync.whenOrNull(
              data: (count) => count > 0
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Dirty: $count',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.cloud_done),
                    ),
            ),
          ),
          
          // Tombol Sinkronisasi
          IconButton(
            icon: const Icon(Icons.sync),
            // Tombol dimatikan (null) jika toggle forceOffline sedang aktif
            onPressed: isOffline ? null : () async {
              final repo = ref.read(noteRepositoryProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menyinkronkan data ke server...')),
              );
              
              // Memanggil fungsi syncNotes Praktikum 3[cite: 12]
              await syncNotes(repo);
              
              ref.invalidate(notesProvider);
              ref.invalidate(dirtyCountProvider);
            },
          ),
          
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(child: Text('Belum ada catatan.'));
          }
          return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return NoteTile(
              note: note,
              onDelete: () async {
              await ref.read(noteRepositoryProvider).deleteNote(note.id!);
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
          await ref.read(noteRepositoryProvider).addNote(
            title: 'Catatan Baru ${DateTime.now().minute}:${DateTime.now().second}',
          );
          ref.invalidate(notesProvider);
          ref.invalidate(dirtyCountProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}