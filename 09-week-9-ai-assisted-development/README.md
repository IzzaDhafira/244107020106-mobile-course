# AI-Assisted Development (Week 9) - Pemrograman Mobile

Implementasi fitur pencarian judul catatan (*search notes*) beserta *empty state* menggunakan pendekatan *AI-Assisted Development* dengan tetap menjaga kepatuhan *feature-first Clean Architecture*.

## Fitur Utama
- Pencarian judul catatan secara *real-time* yang mengabaikan huruf kapital/kecil (*case-insensitive*) dan spasi berlebih (`.trim()`).
- Tampilan *empty state* (`Catatan tidak ditemukan`) saat kata kunci tidak cocok dengan daftar catatan.
- Pemisahan *business logic* ke dalam *use case* murni (`FilterNotes`) di lapisan `domain/`.

## Ringkasan Prompt Inti (Formula 5 Slot)
- **Peran:** Senior Flutter Developer
- **Konteks:** Feature-first Clean Architecture (`presentation -> domain <- data`), Riverpod, SQLite + Dio
- **Tugas:** Tambah fitur search judul notes lengkap dengan empty state
- **Batas:** Jangan ubah arsitektur, jangan panggil SQLite/Flutter di `domain/`, fungsi maksimal 40 baris
- **Output:** Kode use case + widget UI + unit test & widget test

## Stack Teknologi
- **Framework:** Flutter & Dart
- **Arsitektur:** Feature-First Clean Architecture (`presentation -> domain <- data`)
- **State Management & Data (Konteks Proyek):** Riverpod, SQLite, Dio
- **Testing:** `flutter_test` (Unit Test & Widget Test)

## Struktur Direktori
```text
09-week-9-ai-assisted-development/
├── docs/
│   ├── ai-log.md           # Log prompt, output AI, bukti grep/test, tabel keputusan
│   └── reflection.md       # Jawaban refleksi Week 9
├── lib/
│   └── features/notes/
│       ├── domain/
│       │   ├── entities/note.dart
│       │   └── usecases/filter_notes.dart
│       └── presentation/
│           └── widgets/note_search_page.dart
├── screenshots/            # Bukti uji manual & output terminal
├── test/
│   └── filter_notes_test.dart
├── pubspec.yaml
└── README.md