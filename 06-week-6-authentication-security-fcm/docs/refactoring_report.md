# Laporan Refactoring & Testing - Campus Notify

## 1. Rincian Refactoring Kode
Untuk memenuhi standar industri, menjaga kerapian arsitektur, dan memisahkan tanggung jawab kode (*separation of concerns*), berikut adalah tiga poin refactoring utama yang telah diterapkan:

* **Pemisahan Konstanta Rute (`lib/routes.dart`)**:
  Memindahkan seluruh string rute (`/login`, `/`, `/pengumuman/:id`) ke dalam satu file terpusat menggunakan kelas `Routes`. Hal ini memastikan deep link dari FCM dan GoRouter menggunakan referensi konstanta yang sama persis tanpa *hardcode*.
  
* **Ekstraksi Fungsi Murni Parsing (`routeFromMessage`)**:
  Memisahkan logika pembacaan `RemoteMessage` menjadi fungsi murni `routeFromMessage(Map<String, dynamic> data)`. Pendekatan ini memungkinkan logika rute diuji secara independen tanpa harus menginisialisasi modul Firebase yang berat.

* **Penanganan Error API (`lib/data/api_errors.dart`)**:
  Memindahkan pemetaan pengecualian Dio (`DioException`) menjadi fungsi penanganan pesan ramah pengguna (seperti menangani status 401, timeout, dan kondisi offline). Dengan ini, lapisan UI hanya menerima string pesan error yang siap ditampilkan, bukan *exception* mentah.

---

## 2. Unit Testing tanpa Firebase (`test/auth_push_test.dart`)
Pengujian unit dijalankan secara independen tanpa memerlukan dependensi Firebase sungguhan. Fokus pengujian mencakup:
* Pengujian fungsi `routeFromMessage` dalam menangani rute kosong, rute tanpa garis miring awal, serta payload ID pengumuman.
* Pengujian *provider* autentikasi dalam membaca status login berdasarkan ketersediaan token akses.
* Pengujian logika penanganan token penyegar (*refresh token*) yang gagal agar otomatis membersihkan sesi dan memaksa pengguna melakukan login ulang.

---

## 3. Hasil Verifikasi & Analisis
* **`flutter analyze`**: Berhasil dijalankan dan bersih dari error fungsional.
* **`flutter test`**: Seluruh skenario pengujian unit pada file *test* dinyatakan lulus (*All tests passed!*).