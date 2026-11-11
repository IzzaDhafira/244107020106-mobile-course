# Simulasi Perbaikan Pesan Commit

| Pesan Commit Lama (Sebelum) | Pesan Commit Konvensional (Sesudah) | Alasan Perubahan |
| :--- | :--- | :--- |
| `final praktikum 7` | `feat(praktikum7): selesaikan implementasi routing dan navigasi halaman` | Pesan lama tidak menjelaskan apa yang dikerjakan. Format baru menjelaskan penambahan fitur (feat) spesifik. |
| `final praktikum 6` | `feat(praktikum6): tambahkan widget layout dasar dan styling` | Menambahkan konteks bahwa commit ini berisi penambahan fitur layout pada minggu ke-6. |
| `final praktikum 5` | `feat(praktikum5): integrasi dasar hello world flutter` | Memperjelas bahwa commit berisi inisialisasi fitur awal flutter. |


# Mid-Project Review Checklist (Week 8)

## 1. Arsitektur & Struktur Proyek
- [x] Menerapkan struktur *feature-first* secara konsisten.
- [x] Sterilitas modul terverifikasi (bebas dari *import* lintas layer yang melanggar aturan).
- [x] Pemisahan yang jelas antara lapisan UI, *Use Case*, dan *Data*.

## 2. Pemeriksaan Mesin (Static Analysis & Testing)
- [x] **`flutter analyze`**: Bersih, *No issues found!*
- [x] **`dart format`**: Seluruh berkas kode telah diformat sesuai standar.
- [x] **`flutter test`**: Lolos dan berjalan hijau (*passed*).
- [x] **CI Automation**: Berkas `.github/workflows/ci.yml` aktif untuk memvalidasi PR secara otomatis.

## 3. Kolaborasi & Git Hygiene
- [x] Riwayat commit menggunakan format Conventional Commits (`feat:`, `docs:`, dll).
- [x] Minimal 1 PR kecil dari *branch* fitur (`feat/notes-validation`) ke `develop` telah dibuka, direview dengan pola (observasi → dampak → usulan konkret), disetujui, dan di-*merge* menggunakan *squash and merge*.
- [x] Berkas `README.md` telah diperbarui memuat status paruh semester serta peta *issue/PR*.

## 4. Status Kesiapan
- **Status Akhir**: **LOLOS / DEFINISI SELESAI** 🚀
- **Catatan**: Fondasi aplikasi telah siap, stabil, dan dapat diandalkan untuk melanjutkan pengembangan di paruh kedua semester.