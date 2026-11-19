# Testing & Quality Assurance (Week 12) - Pemrograman Mobile

Implementasi *automated testing* menyeluruh pada fitur manajemen daftar tugas dan catatan (*Note Manager*), mencakup *unit test*, *dependency fake test*, *widget test*, *end-to-end flow test*, serta laporan cakupan kode (*test coverage*).

## Struktur Direktori

```text
12-week-12-testing-quality-assurance/
├── coverage/
│   └── lcov.info
├── screenshots/
├── test/
│   └── note_suite_test.dart
└── README.md
```

## Skenario Pengujian yang Diterapkan

1. **Unit Test — Validasi & Aturan Bisnis (`NoteService`):**
   - Menolak judul catatan kosong atau hanya berisi spasi (`'   '`) dengan pesan error yang jelas.
   - Menolak kasus tepi (*edge case*) panjang judul kurang dari 3 karakter (`'ab'`).
   - Menerima judul valid sekaligus membersihkan spasi berlebih di awal/akhir teks (`.trim()`).
2. **Dependency Test — Fake Repository (`FakeSuccessRepository` & `FakeErrorRepository`):**
   - Menguji pengambilan daftar catatan secara konsisten menggunakan `FakeSuccessRepository` tanpa bergantung pada jaringan atau database perangkat.
   - Mensimulasikan kegagalan koneksi/penyimpanan menggunakan `FakeErrorRepository` untuk memastikan *exception* tertangani dengan baik.
3. **Widget Test — Interaksi UI (`NoteManagerPage`):**
   - Memverifikasi tampilan awal kosong (`Belum ada catatan`) saat daftar masih kosong.
   - Memverifikasi kemunculan teks peringatan merah (`Judul minimal 3 karakter`) saat pengguna memasukkan input tidak valid.
   - Memverifikasi penambahan item baru ke layar setelah menekan tombol `Tambah` dengan input valid.
   - Memverifikasi tampilan pesan error UI (`Gagal memuat data catatan`) ketika *repository* gagal mengambil data.
4. **End-to-End Flow Test — Alur Utama Pengguna:**
   - Menguji alur utama aplikasi secara menyeluruh mulai dari kondisi awal kosong, validasi input gagal, perbaikan input, hingga data tampil di daftar.

## Perintah Pengujian & Cakupan (*Coverage*)

```bash
flutter analyze
flutter test --coverage
flutter test integration_test/app_test.dart -d <device_id>
```

## Bukti Hasil Analisis, Pengujian, & Temuan

- **`flutter analyze`:** `No issues found!` (0 warning, 0 error)
- **`flutter test --coverage`:** `+10: All tests passed!` (seluruh 10 skenario *unit*, *fake dependency*, *widget*, dan *flow test* lulus serta menghasilkan file laporan cakupan di `coverage/lcov.info`)
- **Temuan / Kendala yang Belum Terselesaikan:** Pengujian integrasi (`integration_test/app_test.dart`) belum dijalankan secara terpisah pada perangkat fisik/emulator Android karena keterbatasan lingkungan emulator lokal saat pengujian dilakukan, sehingga verifikasi alur *end-to-end* dijalankan melalui *widget & flow test suite* dengan perintah `flutter test --coverage`.

---

## Refleksi

### 1. Bug apa yang paling mungkin terlewat tanpa pengujian yang Anda tulis?
Bug pada **kasus tepi (*edge cases*) validasi input** (seperti input yang hanya berisi spasi `'   '` atau panjang tepat di bawah batas minimum 2 karakter) serta **kegagalan penanganan error asinkron** ketika *repository* gagal memuat/menyimpan data, yang tanpa pengujian UI dapat menyebabkan layar tetap berada di status *loading* selamanya atau memicu *unhandled exception*.

### 2. Bagian mana yang perlu fake, dan bagaimana fake itu membuat pengujian lebih konsisten?
Bagian akses penyimpanan data (`NoteRepository`) perlu dibuatkan *fake* (`FakeSuccessRepository` dan `FakeErrorRepository`). Dengan menggunakan *fake* di memori, pengujian tidak bergantung pada koneksi jaringan, database lokal perangkat, atau urutan eksekusi eksternal, sehingga hasil *test* selalu deterministik, cepat, dan mudah mensimulasikan skenario *error* kapan saja.

### 3. Apa perbedaan nilai yang diberikan pengujian widget dan pengujian integrasi pada fitur Anda?
- **Pengujian Widget (`test/note_suite_test.dart`):** Menguji komponen halaman `NoteManagerPage` secara terisolasi dan sangat cepat menggunakan *fake repository* untuk memastikan setiap elemen UI (teks error, tombol, daftar item) merespons *state* dengan tepat.
- **Pengujian Integrasi (`integration_test/app_test.dart`):** Menjalankan aplikasi secara utuh mulai dari `main()` dan menguji alur pengguna *end-to-end* dalam satu rangkaian nyata, memastikan seluruh lapisan (UI, *service*, dan *repository* asli) terhubung tanpa kendala.