# AI Challenge: Analysis & Architecture Decision Record (ADR)

## 1. Prompt Utama ke AI Assistant
> **Prompt:**  
> "Project Flutter saya: campus_notify (auth + FCM + daftar pengumuman).  
> Kondisi kini: folder lib/{data, providers, pages, messaging}, repository tercampur dengan implementasi, widget memanggil Dio langsung.  
> Tugas:  
> 1. Usulkan struktur feature-first Clean Architecture (presentation/domain/data) untuk fitur auth + announcements.  
> 2. Untuk tiap file lama, sebutkan tujuan barunya (pindah/pecah/hapus).  
> 3. Tandai bagian yang over-engineering bila diterapkan ke CRUD sederhana, dan kapan use case benar-benar dibutuhkan vs repository langsung.  
> 4. Tunjukkan wiring DI dengan Riverpod (tanpa package DI tambahan).  
> Jelaskan trade-off setiap keputusan."

---

## 2. Tabel Evaluasi: Usulan AI vs Keputusan Final

| Item Evaluasi | Usulan Awal AI | Keputusan Final Mahasiswa | Alasan Teknis & Trade-Off |
| :--- | :--- | :--- | :--- |
| **Pemisahan Interface Repo** | Menaruh interface dan impl di folder `data/`. | **Diterima dengan Perbaikan**: Interface wajib di `domain/repositories/` dan impl di `data/repositories/`. | Menjaga *Dependency Inversion Principle* (DIP). Layer domain tidak boleh bergantung pada layer data. |
| **Penggunaan Use Case** | Membuat Use Case untuk semua operasi (misal `GetNotes`, `AddNote`, `DeleteNote`). | **Ditolak Sebagian**: Hanya membuat Use Case jika ada logika bisnis gabungan/sinkronisasi. Untuk CRUD sederhana, Notifier langsung memanggil Repository. | Mencegah *over-engineering* dan file *boilerplate* berlebih pada aplikasi bertipe CRUD sederhana. |
| **Pemisahan Entity & Model** | Menyarankan `NoteModel` terpisah total tanpa inheritance dari `Note`. | **Diterima dengan Penyesuaian**: `NoteModel extends Note` di layer data. | Memudahkan konversi `toEntity()` / `fromMap()` tanpa menduplikasi seluruh *properties* milik entity. |
| **Lokasi Helper Database** | Menaruh `openNotesDb` di `notes_providers.dart` (Presentation). | **Diterima & Diperbaiki**: Dipindah ke `data/datasources/note_local_datasource.dart`. | Layer presentation wajib steril dari import paket database (`sqflite`/`path`). |

---

## 3. Pemetaan File Lama ke Struktur Baru

* **`lib/main.dart`** $\rightarrow$ **Dipecah:** UI Screen dipindah ke `presentation/pages/`, rute ke `routes.dart`, dan state ke `auth_provider.dart`. `main.dart` hanya menyimpan inisialisasi awal.
* **`lib/messaging/push_service.dart`** $\rightarrow$ **Dipindah:** Ke `lib/core/push_service.dart` (Utility global).
* **`lib/data/api_client.dart`** $\rightarrow$ **Dipindah:** Ke `lib/core/api_client.dart`.
* **`lib/providers/auth_provider.dart`** $\rightarrow$ **Dipindah:** Ke `lib/features/notes/presentation/providers/auth_provider.dart`.

---

## 4. AI Verification Checklist (Hasil Audit Grep)

 Seluruh verifikasi statis telah lolos 100%:

1. **Presentation Steril dari Data Mentah (Target: 0 Hasil)**
   ```powershell
   Select-String -Path "lib/features/*/presentation/*.dart", "lib/features/*/presentation/**/*.dart" -Pattern "Dio|openDatabase|getDatabasesPath|FlutterSecureStorage|SharedPreferences|jsonDecode"
   # Output: Kosong (0 Hasil)