# ToDo App & Stats (Week 3 Navigation & State Management)

## Tujuan
Aplikasi ini dibangun sebagai bagian dari Mini Project minggu ke-3 untuk memahami dan mengimplementasikan arsitektur state management global menggunakan Riverpod dan navigasi terstruktur menggunakan GoRouter.

## Fitur Utama
- **Manajemen Tugas:** Menambah dan menyelesaikan tugas (*checklist*).
- **Filter Otomatis:** Hanya menampilkan tugas yang belum diselesaikan melalui Riverpod Provider berantai.
- **Navigasi Terpusat:** Menggunakan `GoRouter` dan `ShellRoute` untuk Bottom Navigation Bar.
- **Asinkronitas Kuat:** Simulasi penarikan data statistik dengan `AsyncValue` (Loading, Error Handling, & Success State).

## Stack Teknologi
- **Framework:** Flutter
- **State Management:** `flutter_riverpod` (Notifier & AsyncNotifier)
- **Routing:** `go_router`

## Cara Menjalankan
1. Pastikan dependensi sudah terinstal:
   ```bash
   flutter pub get


# Refleksi

- Kapan setState masih cukup, dan kapan state harus naik ke Riverpod?
setState digunakan untuk state UI sementara (ephemeral), sedangkan Riverpod digunakan untuk data yang di-share antar layar atau butuh persistensi rute.

- Apa perbedaan context.go dan context.push, dan kapan masing-masing tepat digunakan?
context.go mengubah URL secara mutlak (cocok untuk tab bar dasar), sementara context.push menumpuk layar baru di atas stack (cocok untuk halaman detail dengan tombol back).

- Bagaimana AsyncValue mencegah bug dibanding tiga boolean terpisah?
Memaksa penanganan state loading dan error secara eksplisit (mutually exclusive) sehingga mencegah bug layar kosong dibandingkan penggunaan 3 flag boolean manual.

- Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?
Melakukan penyesuaian dari tester.pump() menjadi tester.pumpAndSettle() pada widget_test.dart karena AI gagal mengantisipasi durasi penutupan pop-up dialog bawaan Material, yang menyebabkan pengujian menemukan duplikasi teks di memori.