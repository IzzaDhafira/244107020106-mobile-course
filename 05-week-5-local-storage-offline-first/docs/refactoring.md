# Laporan Verifikasi Mandiri & Testing - Offline Notes

Dokumen ini merangkum hasil verifikasi mandiri dan uji fungsionalitas aplikasi *Offline Notes* sesuai dengan persyaratan modul Praktikum Pemrograman Mobile Minggu ke-5.

## 1. Hasil Checklist Verifikasi Mandiri Refactoring

| Poin Verifikasi | Status | Catatan Implementasi |
| :--- | :--- | :--- |
| **Arsitektur Pemisahan (UI ke Repository)** | **Lolos (Verified)** | Seluruh akses ke SQLite dan SharedPreferences diisolasi di dalam *Repository* (`NoteRepository`, `PrefsRepository`) dan dikelola melalui Riverpod *Provider*. Tidak ada pemanggilan basis data langsung di dalam widget UI. |
| **Fungsionalitas Penuh Mode Pesawat** | **Lolos (Verified)** | Operasi CRUD (baca, tambah, hapus catatan) tetap berjalan lancar tanpa error saat perangkat berada dalam mode offline / pesawat. |
| **Akurasi Badge & Sync** | **Lolos (Verified)** | *Badge* indikator "Belum tersinkron" / *dirty* muncul otomatis saat data ditambahkan secara lokal dan berubah menjadi ikon awan tersinkron setelah proses simulasi *sync* dijalankan. |
| **Analisis & Unit Testing** | **Lolos (Verified)** | Perintah `flutter analyze` menghasilkan *No issues found!*, dan seluruh *unit test* di dalam folder `test/` lulus hijau (*passed*). |
| **Dokumentasi AI Challenge** | **Lolos (Verified)** | Analisis perbandingan *storage* (SharedPreferences, Hive, sqflite, Drift) serta verifikasinya telah didokumentasikan di folder `docs/`. |

---

## 2. Ringkasan Pengujian (Unit Test)
Pengujian otomatis menggunakan `flutter_test` dan *mock provider* (`FakeNoteRepository`) memastikan bahwa:
- Model `Note` aman terhadap pemetaan data kosong/hilang dari *Map*.
- *Flag* status `dirty` bertahan dengan baik pada proses serialisasi.
- Provider Riverpod menangani respon sukses maupun penanganan galat (*error handling*) dari repositori dengan stabil tanpa gangguan *lifecycle*.

---

## 3. Kesimpulan Akhir
Kombinasi penggunaan **SharedPreferences** untuk penyimpanan preferensi tema ringan dan **sqflite (SQLite)** untuk pengelolaan koleksi data catatan berskala besar terbukti menjadi solusi yang stabil, efisien secara memori, serta memberikan kontrol penuh atas arsitektur *offline-first* dan antrean sinkronisasi (*dirty flag*).