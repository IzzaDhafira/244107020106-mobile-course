# AI Prompt Challenge & Verifikasi - Offline Notes

## 1. Prompt AI yang Digunakan
> "Aplikasi Flutter Offline Notes: CRUD catatan + preferensi tema. Bandingkan SharedPreferences, Hive, sqflite (SQLite), dan Drift untuk dua kebutuhan ini. Requirements:
> - Kriteria: kompleksitas query, kebutuhan relasi, reaktivitas (stream), type-safety, ukuran boilerplate, dan kemudahan testing.
> - Beri rekomendasi final: mana untuk preferensi, mana untuk catatan, beserta alasannya dalam 1 tabel.
> - Tunjukkan skema tabel/kotak untuk 1000+ catatan.
> Jelaskan trade-off setiap pilihan."

---

## 2. Tabel Perbandingan Final (Output Analisis)

| Kriteria | SharedPreferences | Hive | sqflite (SQLite) | Drift |
| :--- | :--- | :--- | :--- | :--- |
| **Kompleksitas Query** | Sangat Rendah (Key-Value) | Sedang (NoSQL iterasi) | Sangat Tinggi (SQL asli) | Sangat Tinggi (SQL builder) |
| **Kebutuhan Relasi** | Tidak Ada | Terbatas (HiveList) | Tinggi (JOIN) | Tinggi (Relasi objek) |
| **Reaktivitas (Stream)**| Tidak bawaan | Ya (ValueListenable) | Tidak bawaan | Ya (Bawaan otomatis) |
| **Type-Safety** | Lemah | Tinggi (TypeAdapter) | Lemah (Map/String) | Sangat Tinggi (Codegen) |
| **Ukuran Boilerplate** | Sangat Kecil | Sedang (Codegen) | Tinggi (Manual mapping) | Sangat Tinggi (Codegen) |
| **Kemudahan Testing** | Sangat Mudah (Mocking) | Mudah | Sedang (Mock DB) | Mudah (In-memory DB) |

---

## 3. Rekomendasi Final & Alasan

| Kebutuhan | Pilihan Final | Alasan Utama |
| :--- | :--- | :--- |
| **Preferensi Tema** | **SharedPreferences** | Hanya menyimpan tipe data primitif tunggal (*boolean*). Menggunakan *database* relasional untuk data seringan ini adalah *over-engineering*. |
| **Entitas Catatan** | **sqflite** | Sangat andal untuk menangani 1000+ data karena memiliki indeks dan sistem *query* SQL yang efisien secara memori. SharedPreferences ditolak untuk koleksi data karena merender string JSON yang rapuh. |

---

## 4. Skema Tabel Catatan (Skala 1000+ & Offline-First)

Skema relasional yang mendukung antrean *sync* dan pencegahan kehilangan data:
* `id`: INTEGER PRIMARY KEY AUTOINCREMENT
* `title`: TEXT NOT NULL
* `body`: TEXT NOT NULL DEFAULT ''
* `updated_at`: TEXT NOT NULL (Krusial untuk resolusi konflik sinkronisasi *last-write-wins*).
* `dirty`: INTEGER NOT NULL DEFAULT 0 (Bendera penanda antrean: 1 jika diubah lokal, 0 jika sudah sync).
* `is_deleted`: INTEGER NOT NULL DEFAULT 0 (Pendekatan *soft-delete* saat offline).

---

## 5. AI Verification Checklist & Keputusan Final

- **SharedPreferences untuk catatan?** Ditolak. Sangat rapuh untuk koleksi data dalam jumlah banyak.
- **Dukungan Antrean Sync?** Skema manual ditambahkan melalui *field* `dirty` dan `updated_at`.
- **Klaim Reaktif?** Reaktivitas sqflite diimplementasikan menggunakan invalidasi state manual (`ref.invalidate`) pada arsitektur Riverpod.
- **Keputusan Final:** Kombinasi **SharedPreferences** (untuk tema) dan **sqflite** (untuk catatan) dipilih karena kestabilan performa *native query* serta kontrol penuh atas mekanisme *offline-first* tanpa kompleksitas *code generation* yang berlebih.