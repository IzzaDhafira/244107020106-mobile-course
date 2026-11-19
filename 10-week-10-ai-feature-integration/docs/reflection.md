# Refleksi AI Feature Integration (Week 10)

## 1. Fitur AI mana yang Anda integrasikan dan mengapa?
Saya mengintegrasikan **AI Chat Assistant** menggunakan Gemini REST API (`gemini-2.5-flash`) ke dalam aplikasi catatan. Fitur ini dipilih karena langsung membantu pengguna merangkum poin catatan, menyusun *to-do list*, dan bertukar ide secara cepat tanpa keluar dari aplikasi.

## 2. Bagaimana Anda melindungi privasi pengguna saat menggunakan AI API?
1. **Penyimpanan Kredensial Aman:** API Key tidak di-*hardcode* di dalam kode sumber maupun repositori Git, melainkan disimpan terenkripsi di perangkat menggunakan `flutter_secure_storage`.
2. **Minimisasi & Anonimisasi Data:** Pengguna diarahkan lewat *placeholder* input untuk tidak mengirimkan data sensitif (NIK, nomor telepon, alamat, kata sandi), dan *system prompt* membatasi AI agar tidak meminta informasi pribadi.

## 3. Fallback apa yang Anda sediakan jika layanan AI error?
Jika API gagal dihubungi (*timeout*, status HTTP non-200, kuota habis, atau perangkat *offline*), blok `try-catch` pada `ChatScreen` menangkap *exception* dan menampilkan `AlertDialog` ramah bertajuk **"Layanan AI Sibuk"** dengan opsi untuk mencoba lagi nanti atau tetap menggunakan fitur catatan lokal (*offline mode*), sehingga aplikasi tidak *crash*.

## 4. Satu hal yang Anda pelajari tentang UX fitur AI di mobile?
Respons AI melalui jaringan membutuhkan waktu beberapa detik sehingga **umpan balik visual yang jelas sangat krusial**. Menampilkan indikator *loading* (`CircularProgressIndicator`), menonaktifkan tombol kirim ganda selama *request* berlangsung, serta memberikan pesan kesalahan yang mudah dipahami jauh lebih baik daripada membiarkan layar diam atau menampilkan pesan error teknis mentah.