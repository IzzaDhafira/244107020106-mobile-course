# Aplikasi Offline Notes - Tugas Pemrograman Mobile Minggu ke-5

Aplikasi Flutter *Offline Notes* yang menerapkan arsitektur *offline-first* dengan basis data relasional SQLite dan manajemen state Riverpod.

## Pemenuhan Kriteria Tugas (Fitur)
1. **Preferensi:** Mendukung *toggle* tema Gelap/Terang dan pencatatan "Waktu Terakhir Dibuka" menggunakan `SharedPreferences`.
2. **CRUD Catatan Persisten:** Menggunakan `sqflite` untuk menyimpan catatan secara persisten, diurutkan berdasarkan tanggal terbaru (`updated_at DESC`).
3. **Mekanisme Offline-First:** Menggunakan aturan penyelesaian konflik *last-write-wins*, pendekatan *cache-first*, serta parameter `dirty` untuk menahan antrean data (sinkronisasi) yang dimodifikasi saat *offline*.
4. **Unit Test:** Dilengkapi dengan 3 pengujian: keamanan pemetaan Map (*model test*), pengujian *provider* sukses, dan *error handling* menggunakan kelas `FakeNoteRepository`.

## Jawaban Refleksi Tugas

* **Mengapa daftar catatan tidak boleh disimpan di SharedPreferences? Apa yang rusak jika aturan ini dilanggar?**
  * *Jawaban:* `SharedPreferences` didesain hanya untuk konfigurasi ringan (tipe primitif). Jika digunakan menyimpan daftar catatan (misal 1000+ objek), seluruh data harus diserialisasi menjadi satu *string* JSON raksasa. Hal ini akan memonopoli memori RAM, memperlambat proses *parsing* aplikasi (*jank/lag*), dan rentan membuat data *corrupt* bila terjadi gagal simpan di tengah jalan.
  
* **Kapan cache-first cukup, dan kapan Anda membutuhkan strategi lain (misalnya network-first)?**
  * *Jawaban:* *Cache-first* sangat cukup untuk data statis seperti artikel, profil, atau catatan harian agar aplikasi bisa langsung digunakan tanpa jeda *loading* (responsif offline). Strategi *network-first* wajib digunakan jika validitas real-time sangat krusial, contohnya seperti sistem harga saham, ketersediaan kursi pesawat, atau saldo rekening.
  
* **Bagaimana dirty flag berubah menjadi antrean sync tanpa memblokir UI? Kapan antrean terpisah (tabel outbox) menjadi perlu?**
  * *Jawaban:* `dirty flag` (nilai boolean/1) menandai data lokal yang dimodifikasi. UI hanya bertugas menampilkan catatan beserta *badge* indikatornya lalu lanjut bekerja tanpa menunggu internet. Proses `syncNotes` berjalan asinkron di belakang layar untuk menyetor data kotor tersebut. Tabel antrean khusus (*outbox*) menjadi perlu jika transaksi melibatkan modifikasi kompleks berurutan yang riwayatnya tidak boleh hilang (contoh: *order* belanja) atau membutuhkan skenario pengulangan upload (*exponential retry*).
  
* **Bagian mana dari rekomendasi AI yang Anda tolak, dan mengapa?**
  * *Jawaban:* Saran penggunaan pustaka NoSQL yang berat seperti `Hive` atau `Drift` untuk menyimpan preferensi tema saya tolak. Menggunakan database yang kompleks untuk sekadar menyimpan *boolean* True/False adalah bentuk *over-engineering* yang tidak efisien.