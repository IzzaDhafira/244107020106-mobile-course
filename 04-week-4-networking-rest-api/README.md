# Minggu 4: Networking & REST API

Mini project ini adalah aplikasi Flutter yang mengonsumsi REST API publik (JSONPlaceholder) untuk menampilkan daftar data postingan dan komentar. Proyek ini mendemonstrasikan pemisahan lapisan (UI, Provider, Repository), manajemen state asinkron yang aman, dan *infinite scrolling*.

## Tujuan
- Menerapkan arsitektur yang bersih dengan memisahkan UI dan pemanggilan HTTP (Dio).
- Mengelola state asinkron (Loading, Success, Error, Empty) menggunakan Riverpod.
- Menerapkan *pagination* (server-side) dengan pencegahan *double-request*.
- Melakukan *Unit Testing* pada model (*Null-Safety*) dan *Mock Repository*.

## Fitur Utama
1. **Daftar Postingan (Paged):** Menampilkan daftar postingan dengan fitur *infinite scrolling* (10 item per halaman).
2. **Detail Postingan:** Navigasi ke halaman detail menggunakan `go_router` dengan membawa data (*extra*).
3. **Komentar Postingan:** Mengambil data komentar berdasarkan ID postingan.
4. **Penanganan Error Terpusat:** Memetakan exception jaringan (timeout, 404, 500, no internet) ke pesan UI yang ramah pengguna, dilengkapi tombol *Retry*.

## Stack Teknologi
- **Framework:** Flutter
- **HTTP Client:** Dio (terpusat dengan *timeout*).
- **State Management:** flutter_riverpod (AsyncNotifier & FutureProvider).
- **Routing:** go_router.

## Cara Menjalankan
1. Pastikan sudah menjalankan `flutter pub get` untuk menginstal semua dependensi.
2. Jalankan aplikasi di emulator atau perangkat fisik menggunakan perintah `flutter run`.
3. Untuk menjalankan *unit test*, ketikkan `flutter test` di terminal.
4. Untuk mengecek kebersihan kode, ketikkan `flutter analyze`.

## Hasil yang Dicapai
Aplikasi dapat menangani koneksi lambat tanpa *crash*, *null-safety* pada model berjalan sempurna meskipun data API cacat, dan performa UI tetap responsif berkat *pagination*. Seluruh pengujian (*test*) berhasil dilewati (*Passed*). Dokumentasi AI Challenge dapat dilihat di dalam folder `docs/`.

---

## Refleksi

**1. Mengapa UI dilarang memanggil Dio langsung? Apa yang rusak jika aturan ini dilanggar?**
UI dilarang memanggil Dio langsung untuk menjaga prinsip *Separation of Concerns* (pemisahan tanggung jawab). UI seharusnya hanya bertugas merender tampilan, bukan mengurus logika jaringan. Jika dilanggar, kode akan menjadi berantakan (*spaghetti code*), sulit dipelihara, dan sangat sulit untuk diuji (*unit testing*) karena kita tidak bisa menyuntikkan (*mock*) repository palsu. Selain itu, jika ada perubahan konfigurasi API, kita harus merombak banyak file UI.

**2. Kapan pagination client-side cukup, dan kapan harus mengandalkan pagination server (_page/_limit)?**
- **Client-side cukup** digunakan ketika total data dari server berjumlah sedikit, ukurannya kecil, dan cenderung statis (misalnya daftar provinsi atau kategori). 
- **Server-side wajib** digunakan ketika data berjumlah masif, dinamis, dan terus bertambah (misalnya *feed* postingan atau riwayat transaksi). Hal ini penting untuk menghemat RAM perangkat, mengurangi beban kuota internet pengguna, dan mempercepat waktu *loading* awal aplikasi.

**3. Bagaimana exception repository berubah menjadi AsyncError tanpa try/catch di setiap widget? Kapan try/catch eksplisit tetap dibutuhkan?**
Di Riverpod, ketika *repository* melempar *exception* (seperti `DioException`), fungsi `build()` pada provider (seperti `AsyncNotifier` atau `FutureProvider`) secara otomatis menangkapnya dan mengubah *state* menjadi `AsyncError`. Widget UI cukup memantaunya menggunakan pola `.when(data: ..., error: ..., loading: ...)`. 
Namun, **`try/catch` eksplisit tetap dibutuhkan** untuk aksi yang memicu mutasi di luar fungsi `build()`, seperti pada fungsi `loadNextPage()` untuk pagination, fungsi `refresh()` manual, atau saat melakukan operasi POST/PUT/DELETE.

**4. Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?**
Bagian utama yang saya perbaiki dari hasil AI adalah saran penggunaan *class* `AutoDisposeFamilyAsyncNotifier` saat membuat provider untuk memuat komentar. Kode tersebut memicu *error* referensi karena *class* tersebut tidak dikenali/kompatibel dengan versi `flutter_riverpod` (tanpa *code-generation*) yang digunakan dalam proyek ini. Saya memperbaikinya dengan mengubah pendekatannya menggunakan `FutureProvider.family` karena jauh lebih stabil, didukung penuh oleh versi Riverpod yang dipakai, dan tetap memberikan kemampuan penanganan *error* otomatis (`AsyncValue`) yang sama persis sesuai instruksi.