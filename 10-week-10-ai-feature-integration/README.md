# AI Feature Integration (Week 10) - Pemrograman Mobile

Integrasi fitur **AI Chat Assistant** pada aplikasi Flutter menggunakan Gemini REST API, `flutter_secure_storage`, indikator *loading*, serta penanganan *error fallback*.

## Struktur Direktori

```text
10-week-10-ai-feature-integration/
├── docs/
│   ├── ai-log.md
│   └── reflection.md
├── lib/
│   ├── ai/
│   │   └── ai_service.dart
│   ├── features/
│   │   └── chat_screen.dart
│   └── main.dart
├── screenshots/
├── test/
│   └── ai_chat_test.dart
├── pubspec.yaml
└── README.md
```

## Tabel Risiko & Mitigasi (Privasi & Biaya)

| Risiko | Mitigasi yang Diterapkan |
| :--- | :--- |
| **Kebocoran API Key & Data Sensitif** | API key disimpan terenkripsi menggunakan `flutter_secure_storage` (tidak di-hardcode di Git); input pengguna dibatasi agar tidak mengirim NIK, nomor telepon, atau alamat. |
| **Biaya / Kuota API Melonjak** | Validasi input kosong sebelum *request*, mencegah pengiriman ganda saat status `_isLoading`, serta membatasi respons tetap ringkas melalui `systemInstruction`. |
| **API Error / Perangkat Offline** | Menangkap kegagalan HTTP/jaringan menggunakan `try-catch` dan menampilkan dialog *fallback* ramah (`Layanan AI Sibuk` dengan opsi mode *offline*). |
| **Respons Tidak Relevan** | Menetapkan `systemInstruction` spesifik agar AI berperan sebagai asisten produktivitas catatan. |

## Cara Menjalankan & Menguji

```bash
cd 10-week-10-ai-feature-integration
flutter pub get
flutter analyze
flutter test
```

## Bukti Mesin Hijau

- **`flutter analyze`:** `No issues found!` (0 warning, 0 error)
- **`flutter test`:** `+3: All tests passed!` (menguji respons sukses API, validasi API key kosong, serta widget test dialog *fallback* saat error)