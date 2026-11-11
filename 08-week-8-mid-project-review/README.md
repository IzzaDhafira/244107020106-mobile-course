# Mid-Project Review (Week 8) - Pemrograman Mobile

Repositori ini berisi laporan status tengah semester, struktur arsitektur *feature-first*, serta bukti kolaborasi dan pengujian mesin dari proyek pengembangan aplikasi di paruh pertama semester.

## Status Paruh Semester
- **Fase Proyek:** Mid-Project Review selesai dan siap dilanjutkan ke paruh kedua.
- **Arsitektur:** Menggunakan pola *feature-first Clean Architecture* (`presentation -> domain <- data`).
- **Status Mesin:** 
  - `flutter analyze`: Bersih (No issues found)
  - `dart format`: Terformat rapi
  - `flutter test`: Lolos dan hijau (*passed*)

## Peta Issue & Pull Request
- **Fitur Utama yang Direview:** Validasi judul kosong pada modul *Notes* dan integrasi pengujian.
- **Branch Strategy:** 
  - Pengembangan fitur dikerjakan di *branch* fitur (`feat/notes-validation`).
  - Digabungkan ke *branch* `develop` melalui *Pull Request* menggunakan metode *Squash and Merge*.
- **CI Automation:** Diaktifkan melalui GitHub Actions (`.github/workflows/ci.yml`) untuk memvalidasi otomatis setiap PR yang masuk.

## Stack Teknologi
- **Framework:** Flutter & Dart
- **State Management:** Riverpod
- **Navigasi:** GoRouter
- **Penyimpanan Lokal:** SQLite
- **Network / API:** Dio

## Struktur Direktori Proyek
```text
08-week-8-mid-project-review/
├── .github/workflows/ci.yml    # Konfigurasi Continuous Integration (CI)
├── docs/                       # Dokumentasi checklist, analisis AI, dan refleksi
│   ├── review-checklist.md
│   ├── ai-review-vs-keputusan.md
│   └── reflection.md
├── test/                       # Berkas unit test & widget test
├── pubspec.yaml                # Konfigurasi dependensi proyek
└── README.md                   # Dokumentasi utama mid-project
```

## Cara Menjalankan Proyek
1. Clone repositori ini ke komputer lokal Anda.
2. Masuk ke direktori modul:
```bash
cd 08-week-8-mid-project-review
```
3. Unduh semua dependensi Flutter:
```bash
flutter pub get
```
4. Jalankan analisis statis untuk memastikan kode bersih:
```bash
flutter analyze
```
5. Jalankan rangkaian pengujian (*testing*):
```bash
flutter test
```

## Hasil yang Dicapai
- Penerapan disiplin *Git hygiene* dan *peer review* yang bertanggung jawab.
- Dokumentasi perbandingan saran AI vs keputusan teknis arsitektur yang objektif.
- Fondasi aplikasi yang stabil dan siap dikembangkan pada paruh kedua semester.