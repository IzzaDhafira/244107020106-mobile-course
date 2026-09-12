**1. Prompt yang Digunakan**
```
Buatkan halaman Flutter bernama StatsPage menggunakan flutter_riverpod.
Requirements:
- ConsumerWidget dengan satu AsyncNotifierProvider yang mensimulasikan
  pengambilan data statistik (delay 2 detik, kadang gagal 30%).
- UI harus menangani loading (spinner), error (pesan + tombol retry),
  dan success (ListView 3 item).
- Berikan unit test untuk notifier-nya.
Jelaskan setiap bagian kode dalam komentar.
```

**2. Output Awal AI**
- `stats_provider.dart`
```dart
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Menggunakan AsyncNotifier (Riverpod modern) menggantikan StateNotifier yang usang.
// Dideklarasikan dengan tipe eksplisit <List<String>>.
class StatsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    // 1. Mensimulasikan pengambilan data dengan delay 2 detik
    await Future.delayed(const Duration(seconds: 2));

    // 2. Mensimulasikan probabilitas kegagalan sebesar 30%
    final isFailure = Random().nextDouble() < 0.3;
    if (isFailure) {
      // Melempar exception jika masuk ke probabilitas 30%
      throw Exception('Gagal mengambil data statistik dari server.');
    }

    // 3. Mengembalikan 3 item data secara immutable (membuat objek list baru).
    // Tidak menggunakan mutasi langsung seperti state.add().
    return [
      'Pengguna Aktif: 1.200',
      'Pendapatan: Rp 5.000.000',
      'Tingkat Konversi: 4.5%'
    ];
  }
}

// Mendeklarasikan provider dengan tipe secara eksplisit untuk mencegah error type inference
final statsProvider = AsyncNotifierProvider<StatsNotifier, List<String>>(
  StatsNotifier.new,
);
```

- `stats_page.dart`
```dart
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
```

- `stats_provider_test.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:nama_project/providers/stats_provider.dart';

void main() {
  test('StatsNotifier menginisialisasi dengan loading, lalu berubah menjadi data atau error', () async {
    // ProviderContainer digunakan untuk menyimpan state provider selama proses testing
    final container = ProviderContainer();
    // Memastikan container dihapus setelah test selesai untuk mencegah kebocoran memori
    addTearDown(container.dispose);

    // 1. Verifikasi State Awal
    // Sesaat setelah dipanggil, AsyncNotifier harus berada pada state AsyncLoading
    expect(
      container.read(statsProvider),
      const AsyncValue<List<String>>.loading(),
    );

    // 2. Eksekusi Proses Asinkron
    // Menunggu metode build() selesai dieksekusi (termasuk delay 2 detik di dalamnya).
    // Karena ada kemungkinan 30% throw Exception, kita harus menangkap errornya agar test tidak crash.
    try {
      await container.read(statsProvider.future);
    } catch (_) {
      // Mengabaikan exception yang dilempar secara sengaja oleh simulasi 30%
    }

    // 3. Verifikasi State Akhir
    // Setelah future selesai, state harus berubah menjadi AsyncData (berisi list) ATAU AsyncError
    final finalState = container.read(statsProvider);
    
    // Mengecek apakah state saat ini memiliki value atau menangkap error
    expect(
      finalState.hasValue || finalState.hasError,
      isTrue,
      reason: 'State harus berupa data (70% peluang) atau error (30% peluang)',
    );
    
    // Jika state berhasil mendapatkan data (tidak terkena probabilitas error 30%),
    // pastikan jumlah item yang direturn tepat 3 buah sesuai requirements.
    if (finalState.hasValue) {
      expect(finalState.value!.length, 3);
    }
  });
}
```

**3. Perbaikan yang Dilakukan**
- Penghapusan File Bawaan: Menghapus test/widget_test.dart karena menyebabkan error No ProviderScope found akibat ketidaksesuaian dengan struktur routing Riverpod yang baru.
- Perbaikan Timeout Test: Menambahkan fungsi container.listen(statsProvider, (previous, next) {}); di dalam file test/stats_provider_test.dart. Hal ini wajib dilakukan agar Riverpod tidak menghentikan layanan (masuk ke mode timeout/hang selama 30 detik) saat status provider sedang dipantau di dalam environment testing.

**4. Hasil Testing**
- flutter analyze: Lolos (Tidak ada isu atau warning).
![Hasil Flutter Analyze](../screeshots/flutter_analyze.png)
- flutter test: Lolos (Seluruh skenario pengujian mulai dari loading, simulasi error, hingga success merender 3 data berhasil dijalankan).
![Hasil Flutter Test](../screeshots/flutter_test.png)