## AI Verification Checklist

Berdasarkan hasil pengujian dan peninjauan kode yang di-*generate* oleh AI, berikut adalah temuan verifikasi untuk implementasi `StatsPage` dan `statsProvider`:

*   **Apakah state diubah secara immutable (tidak ada state.add() atau mutasi list langsung)?**
    Ya, state diubah secara *immutable*. Di dalam `StatsNotifier`, data dikembalikan sebagai objek `List<String>` baru menggunakan perintah `return [...]` secara langsung. Tidak ada penggunaan metode mutasi seperti `state.add()`.

*   **Apakah ref.watch hanya dipakai di dalam build, dan ref.read di callback?**
    Ya, pemanggilan `ref.watch(statsProvider)` dipastikan hanya berada di dalam metode `build()` pada `ConsumerWidget` untuk mendengarkan perubahan *state*. Untuk *callback* pada tombol Retry, kode menggunakan `ref.invalidate()` yang merupakan pola Riverpod modern untuk mereset *state* (bekerja layaknya `ref.read`).

*   **Apakah ketiga state AsyncValue benar-benar ditangani (bukan hanya success)?**
    Ya, ketiga *state* telah tertangani sepenuhnya menggunakan metode `statsAsync.when()`. 
    1. `loading`: Menampilkan `CircularProgressIndicator`.
    2. `error`: Menampilkan pesan teks hasil *exception* (simulasi gagal 30%) beserta tombol *Retry*.
    3. `data`: Menampilkan `ListView.builder` berisi 3 *item* statistik.

*   **Apakah provider dideklarasikan dengan tipe eksplisit dan tidak duplikat dengan provider lain?**
    Ya, `statsProvider` telah dideklarasikan secara eksplisit dengan mendefinisikan tipe kelas dan tipe *return data*-nya: `AsyncNotifierProvider<StatsNotifier, List<String>>`. Nama *provider* juga unik dan tidak tumpang tindih.

*   **Apakah kode AI memakai API Riverpod versi lama (StateProvider antipattern, StateNotifierProvider usang, atau Consumer bertingkat yang tidak perlu)? Perbaiki ke pola Notifier/ConsumerWidget.**
    Tidak, kode AI sudah tidak menggunakan API *legacy*. Kode telah mengadopsi standar Riverpod 2.x ke atas dengan menggunakan `AsyncNotifier` (pengganti `StateNotifier` yang usang) dan membungkus halamannya menggunakan ekstensi `ConsumerWidget` tanpa menumpuk *widget* `Consumer` di dalam *tree*.

*   **Jalankan flutter analyze dan flutter test, apakah hasil AI lolos tanpa warning?**
    Ya, lolos tanpa *warning*. Setelah menyesuaikan *file testing* (menambahkan `container.listen` agar *provider* tidak mengalami *timeout/hang* saat pengujian `AsyncValue`), perintah `flutter test` berjalan sukses melewati skenario verifikasi awal, *loading*, *error*, dan *data*. Perintah `flutter analyze` juga tidak menemukan isu.