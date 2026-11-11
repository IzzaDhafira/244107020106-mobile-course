import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';

// Menggunakan ConsumerWidget sesuai requirements
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch HANYA digunakan di dalam metode build untuk mendengarkan perubahan state
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      // Menangani ketiga kondisi state AsyncValue secara komprehensif
      body: statsAsync.when(
        // Kondisi 1: Loading
        loading: () => const Center(
          // Menampilkan spinner saat menunggu delay 2 detik
          child: CircularProgressIndicator(),
        ),
        
        // Kondisi 2: Error
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Menampilkan pesan error hasil dari probabilitas 30% gagal
              Text('Error: $error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                // Menggunakan ref.invalidate di dalam callback untuk mereset 
                // state dan memicu ulang metode build() pada provider (retry)
                onPressed: () => ref.invalidate(statsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        
        // Kondisi 3: Success
        data: (stats) => ListView.builder(
          // Menampilkan ListView berisi tepat 3 item sesuai data yang di-return
          itemCount: stats.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.analytics),
              title: Text(stats[index]),
            );
          },
        ),
      ),
    );
  }
}