# AI-Assisted Development Log (Week 9)

## 1. Prompt Mentah (Formula 5 Slot)
- **Peran:** Senior Flutter Developer
- **Konteks:** Feature-first Clean Architecture (`presentation -> domain <- data`), Riverpod, SQLite + Dio
- **Tugas:** Tambah fitur search judul notes lengkap dengan empty state
- **Batas:** Jangan ubah arsitektur, jangan panggil SQLite/Flutter di domain, fungsi maksimal 40 baris
- **Output:** Kode use case + widget UI + unit test

## 2. Output Awal AI & Temuan Bug / Halusinasi (Bukti Wajib)
Pada iterasi pertama, AI menghasilkan logika pencarian langsung di dalam widget `NoteSearchPage` dengan memanggil `sqflite` secara langsung serta menggunakan perbandingan string *case-sensitive* (`note.title.contains(query)`), sehingga pencarian kata `"belanja"` gagal menemukan `"Daftar Belanja"`.

### Bukti Verifikasi:
1. **Pengecekan Import (`grep`):**
   Ditemukan `import 'package:sqflite/sqflite.dart';` pada file presentasi/domain awal. Setelah di-refactor, hasil pengecekan `grep -rn "sqflite\|flutter/material" lib/features/notes/domain/` menghasilkan **0 temuan (bersih)**.
2. **Test Merah (Reproduksi Bug):**
   Saat diuji dengan input `'belanja'` pada judul `'Daftar Belanja'`, test gagal (`Expected: length <2>, Actual: <0>`).

## 3. Akar Masalah & Refactoring (Praktikum 3)
- **Akar Masalah:** Pencampuran *business logic* di layer UI dan tidak adanya normalisasi huruf kecil (`.toLowerCase()`) serta pemangkasan spasi (`.trim()`).
- **Solusi:** Memindahkan logika filter ke *use case* murni `FilterNotes` di layer `domain/`, menambahkan `.trim().toLowerCase()`, dan memastikan widget hanya merender state serta *empty state*.

---

## 4. AI Prompt Challenge (Review Kode Search)

### Prompt Review yang Digunakan
> Review kode search Flutter ini sebagai senior dev.
> Konteks: feature-first (presentation->domain<-data), Riverpod, SQLite + Dio.
> Fokus: kebenaran, arsitektur, test. Abaikan style.
> Beri 3 temuan + level blocker/saran + alasan.

### 3 Temuan Review AI & Verifikasi
1. **Temuan 1 (Blocker) - Pemisahan Logika Filter dari Widget:**
   - **Saran AI:** Memastikan logika pencarian berada di layer `domain/usecases/filter_notes.dart` dan bebas dari dependensi Flutter/SQLite.
   - **Verifikasi:** Dibuktikan melalui `flutter analyze` (0 warning) dan pengecekan import bahwa `domain/` murni berisi kode Dart.
   - **Keputusan:** **Diterima + Refactor.**

2. **Temuan 2 (Saran) - Penambahan Widget Test untuk Empty State:**
   - **Saran AI:** Menambahkan `testWidgets` untuk memverifikasi teks `'Catatan tidak ditemukan'` muncul saat hasil pencarian kosong.
   - **Verifikasi:** Dijalankan melalui `flutter test` dan terbukti memvalidasi perilaku UI secara otomatis.
   - **Keputusan:** **Diterima.**

3. **Temuan 3 (Saran) - Menambahkan Debounce Timer & Package Eksternal pada TextField:**
   - **Saran AI:** Mengusulkan penambahan package pihak ketiga (`rxdart`) untuk *debounce* pencarian list lokal.
   - **Verifikasi:** Data catatan sudah berada di memori lokal (*in-memory list*), sehingga operasi filter sinkron berjalan instan tanpa membebani UI.
   - **Keputusan:** **Ditolak dengan alasan teknis tertulis** (menghindari penambahan dependensi eksternal yang tidak perlu dan menjaga fungsi tetap ringkas).

---

## 5. Tabel Usulan AI vs Keputusan Final per File

| File | Usulan AI | Keputusan | Alasan Teknis |
| :--- | :--- | :--- | :--- |
| `domain/entities/note.dart` | Model data `Note` murni Dart | **Terima** | Memenuhi aturan *dependency rule* Clean Architecture. |
| `domain/usecases/filter_notes.dart` | Fungsi filter + normalisasi `.trim().toLowerCase()` | **Terima + Refactor** | Mengisolasi *business logic* agar ringkas (< 40 baris) dan mudah diuji unit test. |
| `presentation/widgets/note_search_page.dart` | UI `TextField`, daftar hasil, *empty state*, dan `rxdart` debounce | **Terima + Refactor** | UI dan *empty state* diterima, namun saran `rxdart` ditolak karena tidak relevan untuk filter list lokal. |
| `test/filter_notes_test.dart` | 3 unit test logika + 1 widget test *empty state* | **Terima** | Memastikan kebenaran logika dan tampilan UI terverifikasi otomatis. |

---

## 6. Bukti Hasil `flutter analyze` & `flutter test`
- `flutter analyze` -> `No issues found!`
- `dart format --set-exit-if-changed .` -> `0 changed` (seluruh file terformat standar)
- `flutter test` -> `+4: All tests passed!` (3 unit test + 1 widget test lulus)

## 7. AI Verification Checklist
- [x] Prompt 5 slot + konteks tersimpan di `docs/ai-log.md`.
- [x] Minimal 1 temuan AI terbukti benar (bukti grep/test) lalu diperbaiki.
- [x] Minimal 1 temuan AI ditolak dengan alasan teknis tertulis (penolakan `rxdart` debounce).
- [x] Keputusan tiap file terdokumentasi jelas (terima, terima + refactor, atau tolak + tulis manual).
- [x] `flutter analyze` bersih dan `flutter test` hijau (+4 passed).
- [x] Mampu menjelaskan seluruh alur kode dan keputusan arsitektur tanpa membuka AI.