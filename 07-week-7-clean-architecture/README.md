## Week 7: Clean Architecture (Feature-First) Refactoring - Campus Notify

Repository ini berisi hasil *refactoring* proyek `campus_notify` dari struktur monolitik menjadi **Feature-First Clean Architecture**.

---

## Tujuan Utama
1. Memisahkan aturan bisnis (*Domain Layer*) agar steril dari kerangka kerja luar (Flutter, Dio, Sqflite, Firebase).
2. Menerapkan pemisahan tanggung jawab (*Separation of Concerns*) dengan 3 layer utama: `Presentation`, `Domain`, dan `Data`.
3. Menerapkan *Dependency Injection* (DI) terpusat menggunakan Riverpod tanpa dependensi tambahan.
4. Menguji domain secara mandiri (*testable*) dengan unit test berbasis *Fake Repository*.

---

## Diagram Layer & Arah Dependensi
```text
+--------------------------------------------------------+
|                   PRESENTATION LAYER                   |
|          (Pages, Widgets, Riverpod Providers)          |
+---------------------------+----------------------------+
                            | (depends on)
                            v
+--------------------------------------------------------+
|                      DOMAIN LAYER                      |
|        (Entities, Use Cases, Repository Interfaces)    |
+---------------------------+----------------------------+
                            ^ (implements)
                            |
+---------------------------+----------------------------+
|                       DATA LAYER                       |
|       (Models/DTOs, Repository Impl, Data Sources)     |
+--------------------------------------------------------+
```

**Aturan Dependensi (*Dependency Rule*):**
* **Presentation** $\rightarrow$ **Domain** $\leftarrow$ **Data**
* **Domain Layer** murni menggunakan Dart dan tidak mengimpor paket luar/framework Flutter.

---

## Struktur Folder Proyek

```text
week7_tugas/
├── lib/
    ├── core/
    │   ├── api_client.dart
    │   ├── failures.dart
    │   ├── format.dart
    │   ├── providers.dart
    │   └── push_service.dart
    ├── features/
    │   └── notes/
    │       ├── data/
    │       │   ├── datasources/
    │       │   │   └── note_local_datasource.dart
    │       │   ├── models/
    │       │   │   └── note_model.dart
    │       │   └── repositories/
    │       │       └── note_repository_impl.dart
    │       ├── domain/
    │       │   ├── entities/
    │       │   │   └── note.dart
    │       │   ├── repositories/
    │       │   │   └── note_repository.dart
    │       │   └── usecases/
    │       │       └── get_notes.dart
    │       └── presentation/
    │           ├── pages/
    │           │   ├── home_page.dart
    │           │   ├── login_page.dart
    │           │   └── notes_page.dart
    │           └── providers/
    │               ├── auth_provider.dart
    │               └── notes_providers.dart
    ├── firebase_options.dart
    ├── main.dart
    └── routes.dart
```

---

## Jawaban Refleksi

### 1. Mengapa interface repository harus tinggal di domain, bukan di data? Apa yang rusak bila dibalik?
Interface repository diletakkan di layer **Domain** untuk menerapkan *Dependency Inversion Principle* (DIP). Domain mendefinisikan *kontrak kebutuhan data* yang dibutuhkannya tanpa peduli bagaimana atau dari mana data tersebut diambil.

* **Dampak Jika Dibalik (Interface di Data Layer):**
  Domain akan terpaksa mengimpor Data Layer. Hal ini merusak *Dependency Rule*, membuat Domain terkontaminasi oleh dependensi fisik dan kerangka kerja luar (seperti SQLite atau REST API), serta memicu *circular dependency* saat implementasi repository (`NoteRepositoryImpl`) mencoba mengimplementasikan interface tersebut.

---

### 2. Kapan use case benar-benar dibutuhkan, dan kapan repository langsung ke notifier sudah cukup?
* **Repository Langsung ke Notifier Sudah Cukup:**
  Saat operasinya adalah CRUD sederhana satu baris (seperti mengambil daftar catatan mentah atau menghapus data) tanpa adanya aturan atau logika bisnis tambahan.
* **Use Case Benar-Benar Dibutuhkan:**
  1. **Orkestrasi Lintas Repository/Service:** Terjadi gabungan beberapa proses (contoh: Login + Simpan Token + Registrasi FCM Token ke Backend).
  2. **Aturan Bisnis Murni:** Ada logika validasi atau transformasi khusus (seperti filter catatan kadaluwarsa, sorting kustom, atau verifikasi hak akses).
  3. **Multiple Entry Points:** Logika yang sama dipanggil dari berbagai tempat berbeda (misalnya dari tombol UI dan dari pustaka penanganan *Push Notification*).

---

### 3. Apa biaya over-engineering (use case per CRUD satu-baris) bagi tim kecil? Kapan biayanya sepadan?
* **Biaya Over-Engineering:**
  Menambah jumlah file *boilerplate* secara signifikan, memperlambat proses *delivery* fitur sederhana, serta memperbanyak lapisan *code-tracing* yang membingungkan tanpa memberikan nilai tambah pada logika aplikasi.
* **Kapan Biayanya Sepadan:**
  Saat proyek dikerjakan oleh tim skala besar, aplikasi memiliki aturan bisnis yang sangat kompleks dan sering berubah, atau saat membutuhkan tingkat *code-reusability* yang sangat tinggi antar-fitur.

---

### 4. Bagian mana dari usulan AI yang Anda tolak atau sederhanakan, dan mengapa?
* **Bagian yang Ditolak:**
  Usulan awal AI untuk membuat *Use Case* terpisah di setiap operasi CRUD satu baris (seperti `AddNoteUseCase`, `DeleteNoteUseCase`).
* **Alasan Teknis:**
  Untuk menghindari *boilerplate code* berlebih (*over-engineering*). Untuk CRUD sederhana, Notifier/Controller di Presentation Layer diposisikan untuk langsung memanggil Repository. *Use Case* hanya dibuat untuk operasi yang memiliki logika bisnis/orkestrasi nyata seperti `GetNotes`.
