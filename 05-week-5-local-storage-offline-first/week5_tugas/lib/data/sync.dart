import 'repositories/note_repository.dart';

Future<int> syncNotes(NoteRepository repo) async {
  final dirtyCount = await repo.countDirty();
  if (dirtyCount == 0) return 0;
  
  await Future.delayed(const Duration(seconds: 1)); // Simulasi upload server
  await repo.markAllSynced();
  return dirtyCount;
}