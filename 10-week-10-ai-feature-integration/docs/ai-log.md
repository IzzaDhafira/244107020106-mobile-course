# AI Feature Integration Log (Week 10)

## 1. System Prompt (Instruksi Sistem pada `AiService`)

```text
Kamu adalah asisten catatan produktivitas. Jawab singkat, jelas, dan jangan pernah meminta data pribadi sensitif.
```

## 2. User Prompt (Pembangunan Fitur)

```text
Integrasikan fitur Chat Assistant menggunakan Gemini REST API pada aplikasi Flutter.
Gunakan flutter_secure_storage untuk menyimpan API key secara aman (jangan hardcode).
Sertakan indikator loading saat request berjalan dan dialog fallback 'Layanan AI Sibuk' jika terjadi error jaringan/API.
```

## 3. Output Awal AI & Penyesuaian Teknis

### Output Awal AI (Ringkasan Kode yang Dihasilkan)
Pada iterasi awal, AI menghasilkan fungsi dasar `ask()` yang memanggil `http.post` ke endpoint `gemini-pro` dan mengambil teks respons mentah dari `candidates[0]['content']['parts'][0]['text']`, serta `TextField` sederhana di UI tanpa validasi input kosong maupun penanganan error spesifik.

### Penyesuaian Teknis yang Dilakukan
1. **Pembaruan Endpoint Model:** Mengganti endpoint `gemini-pro` yang sudah *deprecated* ke model aktif `gemini-2.5-flash`.
2. **Injeksi Dependensi untuk Pengujian (`MockClient`):** Menambahkan parameter opsional `http.Client` dan `FlutterSecureStorage` pada konstruktor `AiService` agar dapat diuji secara terisolasi melalui `flutter_test` tanpa memanggil API sungguhan atau mengekspos API key.
3. **Validasi Input & Pencegahan Spam Request:** Menambahkan pengecekan `question.trim().isEmpty` sebelum pemanggilan API serta menonaktifkan tombol kirim saat `_isLoading == true` untuk menghemat kuota/biaya API.
4. **Error Handling & Fallback UI:** Menambahkan blok `try-catch` pada `ChatScreen` untuk menangkap kegagalan jaringan/HTTP dan menampilkan `AlertDialog` ramah (`Layanan AI Sibuk`).