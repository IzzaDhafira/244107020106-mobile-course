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