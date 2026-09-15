# Laporan AI Verification Checklist & Tanggung Jawab Teknis
**Tugas Minggu Ke-4 (Networking & REST API)**

## 1. Riwayat Prompt dan Perbaikan AI
*   **Prompt yang digunakan:** 
    > *"Buatkan repository layer Flutter untuk endpoint GET /comments?postId={id} dari JSONPlaceholder menggunakan Dio + flutter_riverpod. Requirements: - Model Comment dengan fromJson aman null (postId, id, name, email, body). - CommentRepository dengan method fetchComments(postId) + timeout 10 detik. - AsyncNotifierProvider dengan penanganan error otomatis (AsyncError) dan fungsi pesan error ramah pengguna untuk timeout, connection error, 404, dan 500. - Satu unit test untuk fromJson dengan field yang hilang. Jelaskan setiap bagian kode dalam komentar."*

*   **Output Awal AI:** 
    AI memberikan struktur yang cukup lengkap mencakup Model, Repository, Provider, dan Unit Test. Namun, AI menggunakan `AutoDisposeFamilyAsyncNotifier` pada Riverpod.

*   **Perbaikan yang Dilakukan (Human Intervention):**
    1.  **Mengatasi Konflik Versi Riverpod:** Terdapat *error* (garis merah) `Classes can only extend other classes` karena class `FamilyAsyncNotifier` tidak sepenuhnya didukung di versi Riverpod tanpa *code-generation* yang digunakan pada proyek.
    2.  **Refactoring Provider:** Mengubah `AsyncNotifierProvider.family` menjadi `FutureProvider.family` (`commentsProvider`) yang jauh lebih stabil untuk operasi HTTP GET berparameter tunggal di versi Riverpod saat ini. Fitur *error handling* otomatisnya (AsyncData/AsyncLoading/AsyncError) tetap berfungsi sama persis.
    3.  **Merapikan Import:** Memusatkan semua *provider* dan fungsi *error handler* ke dalam satu file `providers.dart` tanpa menimpa *provider* lama (`postListProvider`).

---

## 2. AI Verification Checklist

*   **Apakah UI memanggil Dio secara langsung (dilarang) atau lewat repository?**
    *   **Lewat Repository.** UI sama sekali tidak mengetahui keberadaan Dio. UI hanya me-listen/memantau `commentsProvider`, yang kemudian memanggil `CommentRepository`. Repository inilah yang membungkus logika pemanggilan `_dio.get(...)`.
*   **Apakah `fromJson` aman null, atau masih memakai cast langsung yang bisa crash?**
    *   **Aman Null.** Di dalam `Comment.fromJson`, tidak ada penggunaan pemaksaan tipe data (seperti `as String` tanpa tanda tanya). Semua *field* menggunakan *fallback operator* (`??`) untuk memberikan nilai *default*. Contoh: `json['name'] as String? ?? 'Unknown'`.
*   **Apakah semua tipe `DioExceptionType` dipetakan ke pesan pengguna?**
    *   **Ya.** Pemetaan dilakukan di fungsi `friendlyErrorMessage`.
        *   `connectionTimeout`, `sendTimeout`, `receiveTimeout` dipetakan menjadi peringatan koneksi lambat.
        *   `connectionError` dipetakan menjadi peringatan internet terputus.
        *   `badResponse` dipecah lebih spesifik (404 untuk tidak ditemukan, 401/403 untuk akses ditolak, 500+ untuk masalah server).
*   **Apakah `baseUrl`/timeout terpusat di satu client, bukan tersebar di tiap method?**
    *   **Terpusat.** Konfigurasi `baseUrl: 'https://jsonplaceholder.typicode.com'` dan `connectTimeout`/`receiveTimeout` sebesar 10 detik diatur di dalam `dioProvider`. Semua *repository* hanya perlu me-read `dioProvider` ini tanpa mengatur ulang *timeout*.
*   **Apakah test AI benar-benar menguji kasus field hilang, atau hanya happy path? Tambahkan minimal 1 edge case sendiri.**
    *   **Ya, test menguji kasus field hilang.** Terdapat skenario pengujian dengan `incompleteJson` di mana atribut `name`, `email`, dan `body` sengaja dihapus.
    *   **[Edge Case Tambahan Sendiri]:** Kami menambahkan satu *test case* baru untuk menguji saat response API memberikan JSON kosong `{}` untuk memastikan aplikasi tetap aman. (Kodenya disertakan di file test).
*   **Jalankan `flutter analyze` dan `flutter test`, apakah hasil AI lolos tanpa warning?**
    *   **Lolos.** Setelah kode disesuaikan dengan `FutureProvider.family` dan *import* diperbaiki, `flutter analyze` berjalan tanpa *error*, dan pengujian `flutter test` menunjukkan semua *test case model* berhasil dilewati (Passed).

## 3. Hasil Testing
- flutter analyze: Lolos (Tidak ada isu atau warning).
![Hasil Flutter Analyze](/screenshots/flutter_analyze.png)
- flutter test: Lolos (Seluruh skenario pengujian mulai dari loading, simulasi error, hingga success merender 3 data berhasil dijalankan).
![Hasil Flutter Test](/screenshots/flutter_test.png)