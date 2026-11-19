# AI Review vs Keputusan Teknis (Challenge)

Dokumen ini mencatat hasil *review* otomatis dari AI menggunakan prompt standar *Senior Flutter Developer* (Fokus: Kebenaran, Arsitektur, dan Test), beserta verifikasi dan keputusan final berdasarkan kondisi nyata kode proyek.

## Daftar Temuan & Verifikasi

### 1. Temuan 1: Potensi Null-Pointer pada State Catatan
- **Saran AI (Blocker):** Menyarankan pengecekan null eksplisit pada inisialisasi state Riverpod untuk mencegah crash saat data kosong.
- **Verifikasi & Bukti:** Setelah diperiksa via analisis dan pengujian, state sudah dihandle dengan *default value* yang aman (`AsyncValue.loading()` / `AsyncValue.data([])`).
- **Keputusan Final:** **Ditolak (Ditolak dengan alasan tertulis).** 
- **Alasan Teknis:** Riverpod secara native sudah mengelola status *async* dengan baik, sehingga pengecekan null manual di tingkat widget menjadi redundan dan melanggar prinsip kebersihan kode.

### 2. Temuan 2: Penambahan Unit Test untuk Validasi Judul Kosong
- **Saran AI (Saran):** Menambahkan skenario test khusus untuk memastikan fungsi validasi menolak string kosong atau spasi (*whitespace*).
- **Verifikasi & Bukti:** Terbukti benar dan sangat penting untuk memastikan keandalan fitur validasi notes.
- **Keputusan Final:** **Diterima.**
- **Alasan Teknis:** Memenuhi kriteria pengujian fungsional dan memastikan `flutter test` mencakup skenario *edge case* negatif.

### 3. Temuan 3: Isolasi Domain dari Ketergantungan Eksternal
- **Saran AI (Blocker):** Memastikan tidak ada *import* package `flutter/material.dart` di dalam folder lapisan `domain/`.
- **Verifikasi & Bukti:** Diperiksa menggunakan analisis struktur direktori *feature-first*, lapisan domain murni berisi logika bisnis tanpa UI.
- **Keputusan Final:** **Diterima.**
- **Alasan Teknis:** Menjaga kepatuhan terhadap aturan *dependency rule* Clean Architecture (`presentation -> domain <- data`).

### 4. Temuan 4: Optimasi Pemanggilan Widget dengan const constructor
- **Saran AI (Nitpick/Style):** Menambahkan keyword `const` pada widget statis untuk efisiensi *rebuild*.
- **Verifikasi & Bukti:** Bagian ini sebenarnya masuk kategori *style* yang sudah otomatis ditangani oleh linter dan `dart format`.
- **Keputusan Final:** **Ditolak / Dialihkan ke Mesin.**
- **Alasan Teknis:** Sesuai batasan tantangan, *style* dan pemformatan diserahkan penuh kepada mesin (`dart format` dan *linter*), bukan menjadi fokus utama review manual.

### 5. Temuan 5: Penanganan Error pada Exception Repository
- **Saran AI (Saran):** Menambahkan *try-catch* spesifik pada pemanggilan data lokal untuk menangani kegagalan baca/tulis penyimpanan.
- **Verifikasi & Bukti:** Ditemukan bahwa penanganan error sudah dibungkus rapi dalam bentuk *Either* atau *AsyncValue* di level state notifier.
- **Keputusan Final:** **Diterima dengan Modulasi.**
- **Alasan Teknis:** Arsitektur saat ini sudah cukup aman, namun saran ini diadopsi sebagai catatan perbaikan untuk pengembangan fitur sinkronisasi di paruh kedua semester.

---

## AI Verification Checklist

Berikut adalah verifikasi mandiri terhadap saran AI sebelum dan sesudah diterapkan ke dalam proyek:

- [x] **Apakah temuan benar-benar ada?** Ya, dibuktikan melalui pengecekan struktur kode, reproduksi skenario *test*, dan hasil analisis lokal.
- [x] **Apakah usulan melanggar dependency rule?** Tidak ada pelanggaran; lapisan *domain* terbukti tetap bersih murni tanpa mengimpor *framework* UI, Flutter, ataupun *packages* eksternal.
- [x] **Apakah AI hanya *nitpick style*?** Ya, sebagian kecil saran AI terkait pemformatan gaya kode (*style*), namun hal tersebut langsung disaring dan diserahkan penanganannya kepada *linter* serta `dart format`.
- [x] **Bukti Temuan Terbukti & Ditolak:** 
  - *Temuan terbukti benar (Min. 2):* Penambahan Unit Test validasi judul kosong (Temuan 2) dan penjagaan aturan *dependency rule* Clean Architecture (Temuan 3).
  - *Temuan ditolak dengan alasan tertulis (Min. 1):* Pengecekan null-pointer manual pada State (Temuan 1) ditolak karena manajemen *state async* Riverpod sudah menanganinya secara aman secara *native*.
- [x] **Keputusan Final:** Keputusan dan argumen teknis diambil sepenuhnya berdasarkan kondisi arsitektur proyek, bukan sekadar menelan mentah-mentah saran dari AI.