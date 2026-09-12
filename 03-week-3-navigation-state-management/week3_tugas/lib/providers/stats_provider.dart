import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    await Future.delayed(const Duration(seconds: 2));
    if (Random().nextDouble() < 0.3) {
      throw Exception('Gagal mengambil data dari server.');
    }
    return [
      'Pengguna Aktif: 1.200',
      'Pendapatan: Rp 5.000.000',
      'Tingkat Konversi: 4.5%'
    ];
  }
}

final statsProvider = AsyncNotifierProvider<StatsNotifier, List<String>>(
  StatsNotifier.new,
);