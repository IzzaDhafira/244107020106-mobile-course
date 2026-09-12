import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week3_todo/providers/stats_provider.dart';

void main() {
  test('StatsNotifier menginisialisasi dengan loading, lalu berubah menjadi data atau error', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // TAMBAHKAN BARIS INI: 
    // Berfungsi sebagai "pancingan" agar provider tidak hang saat ditunggu (await)
    container.listen(statsProvider, (previous, next) {});
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