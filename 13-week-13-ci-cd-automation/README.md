# CI/CD Pipeline dengan GitHub Actions (Week 13) - Pemrograman Mobile

Implementasi otomatisasi **Continuous Integration (CI)** dan **Continuous Delivery (CD)** menggunakan GitHub Actions untuk memeriksa format kode, analisis statis, pengujian otomatis, serta membangun artefak rilis Android (**APK** dan **AAB**).

## Struktur Direktori

```text
13-week-13-ci-cd/
├── .github/
│   └── workflows/
│       └── flutter-ci.yml
├── screenshots/
│   ├── actions-run-success.png
│   └── build-artifacts.png
└── README.md
```

## Tahapan Pemeriksaan Pipeline (`flutter-ci.yml`)

1. **Trigger & Keamanan:** Berjalan otomatis saat `push` atau `pull_request` ke branch `develop` / `main` serta dapat dipicu manual (`workflow_dispatch`), dengan izin minimum `contents: read`.
2. **Pemeriksaan Format:** `dart format --output=none --set-exit-if-changed .`
3. **Analisis Statis:** `flutter analyze --fatal-infos`
4. **Pengujian Otomatis & Cakupan:** `flutter test --coverage`
5. **Build & Penyimpanan Artefak Rilis:** Membangun `app-release.apk` dan `app-release.aab` lalu mengunggahnya melalui `actions/upload-artifact@v4` dengan masa simpan 7 hari.

## Rencana Versioning & Bukti Eksekusi

- **Versi Saat Ini:** `1.0.0+1`
- **Versi Berikutnya (Next Release):** `1.1.0+2` (penambahan otomatisasi CI/CD pipeline dan rilis artefak Android) — ditandai dengan Git tag `v1.1.0` pada commit yang lolos seluruh tahap pemeriksaan.
- **Status Pipeline & Commit:** Lolos seluruh tahapan pemeriksaan CI/CD pada branch `develop` (lihat bukti pada folder `screenshots/`).

## Risiko Keamanan yang Masih Perlu Ditangani

1. **Signing Produksi (Release Keystore):** Saat ini build rilis masih menggunakan *debug signing* bawaan; untuk distribusi publik ke Google Play Store, file `.jks` dan kredensial *keystore* wajib disimpan di **GitHub Actions Secrets** (tidak pernah di-commit ke repositori).
2. **Perlindungan Branch Utama:** Perlu mengaktifkan *Branch Protection Rules* pada `main` dan `develop` agar setiap *Pull Request* wajib menunggu status CI hijau sebelum dapat di-*merge*.
3. **Audit Dependensi & Secret Scanning:** Mengaktifkan pemeriksaan kerentanan paket pihak ketiga secara berkala dan membatasi akses *secret* pada *pull request* dari repositori *fork*.

---

## Refleksi

### 1. Masalah apa yang ditemukan otomatis sebelum perubahan di-merge?
Kesalahan format penulisan kode Dart yang tidak seragam (`dart format`), *warning* atau *info* dari analisis statis (`flutter analyze --fatal-infos`), serta kegagalan *unit/widget test* (`flutter test`) terdeteksi secara otomatis sebelum kode digabungkan ke branch utama.

### 2. Informasi apa yang Anda butuhkan untuk menyelidiki build yang gagal?
Log eksekusi dari setiap *step* pada tab **Actions** GitHub (pesan error spesifik dari compiler/analyzer/test runner), hash **commit** yang memicu pipeline, versi Flutter SDK dan dependensi di `pubspec.lock`, serta hasil pengujian lokal dengan perintah yang sama.

### 3. Bagian mana yang masih perlu persetujuan atau pemeriksaan manual sebelum rilis?
Pengujian fungsional langsung pada perangkat fisik (izin kamera/penyimpanan, performa nyata), peninjauan *changelog* dan aset halaman toko aplikasi, konfigurasi *signing* produksi, serta persetujuan (*code review* / *release approval*) dari tim atau dosen sebelum mengunggah AAB ke Google Play Console.