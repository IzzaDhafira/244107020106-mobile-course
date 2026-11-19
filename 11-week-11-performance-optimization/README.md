# Performance Optimization (Week 11) - Pemrograman Mobile

Optimasi performa rendering, pengurangan *widget rebuild*, *query caching*, dan pencegahan *memory leak* pada aplikasi catatan Flutter menggunakan Flutter DevTools.

## Struktur Direktori

```text
11-week-11-performance-optimization/
├── docs/
│   ├── performance-findings.md
│   ├── performance-report.md
│   └── reflection.md
├── lib/
│   ├── features/notes/
│   │   ├── domain/
│   │   │   ├── entities/note.dart
│   │   │   └── usecases/filter_notes.dart
│   │   └── presentation/
│   │       └── widgets/optimized_notes_page.dart
│   └── main.dart
├── screenshots/
│   
├── test/
│   └── performance_optimization_test.dart
├── pubspec.yaml
└── README.md
```

## Ringkasan Optimasi yang Diterapkan
- **`ListView.builder` + `itemExtent`:** Lazy rendering untuk daftar catatan panjang.
- **`const` Constructor & Widget Extraction (`_NoteCardTile`):** Mencegah *rebuild* widget statis saat pencarian aktif.
- **`RepaintBoundary`:** Isolasi area *repaint* pada setiap kartu catatan.
- **Query Cache & `dispose()`:** Cache hasil pencarian berulang serta pembersihan `TextEditingController` untuk mencegah *memory leak*.

## Cara Menjalankan & Menguji

```bash
cd 11-week-11-performance-optimization
flutter pub get
flutter analyze
flutter test
```

## Bukti Mesin Hijau

- **`flutter analyze`:** `No issues found!` (0 warning, 0 error)
- **`flutter test`:** `+2: All tests passed!` (verifikasi *query cache* dan *lazy rendering* `ListView.builder`)