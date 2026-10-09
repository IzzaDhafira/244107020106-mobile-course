# Campus Notification App

Aplikasi pengumuman kampus berbasis Flutter menggunakan FCM, Riverpod, dan GoRouter.

## Fitur Utama
- **Guard Route**: Pengguna belum login otomatis diarahkan ke `/login`.
- **Keamanan Sesi**: Token akses disimpan di `flutter_secure_storage`.
- **FCM Terintegrasi**: Menggunakan topik `pengumuman-kampus` dan push notifikasi personal.
- **Deep Linking**: Navigasi notifikasi dari ke-3 state aplikasi ke halaman detail spesifik.

## Stack Teknologi
- Flutter & Dart
- Riverpod (State Management)
- GoRouter (Routing)
- Firebase Cloud Messaging (Push Notifications)
- Flutter Secure Storage

## Matriks Pengujian Push Notification
| App State | Aksi | Hasil |
| :--- | :--- | :--- |
| **Foreground** | Notifikasi masuk | Muncul via `flutter_local_notifications`, klik buka `/pengumuman/3` |
| **Background** | Klik dari system tray | Aplikasi terbuka dan *navigate* ke `/pengumuman/3` |
| **Terminated** | Klik dari system tray | Aplikasi melakukan *cold start*, data rute diambil via `getInitialMessage` menuju `/pengumuman/3` |

## Cara Menjalankan
1. `flutterfire configure` untuk menyambungkan ke Firebase.
2. `flutter run`

---

## Refleksi & Jawaban Pertanyaan

### 1. Keamanan Penyimpanan Refresh Token
* **Mengapa tidak boleh menggunakan `SharedPreferences`?**  
  `SharedPreferences` menyimpan data dalam format plain-text XML yang tidak terenkripsi di direktori aplikasi. Pada perangkat Android yang ter-root atau melalui analisis cadangan (*backup analysis*), file ini sangat mudah diakses dan dibaca oleh aplikasi lain maupun pihak ketiga.
* **Risiko Bila Bocor:**  
  *Refresh token* memiliki masa berlaku (*lifetime*) yang panjang. Jika token ini bocor, penyerang (*attacker*) dapat terus-menerus meminta *access token* baru atas nama pengguna tanpa perlu memasukkan kata sandi, yang mengakibatkan pengambilalihan akun secara permanen (*account takeover*) hingga token tersebut dicabut dari server. Oleh karena itu, *refresh token* wajib disimpan di penyimpanan terenkripsi seperti `flutter_secure_storage` (Android Keystore / iOS Keychain).

---

### 2. Dampak Mengabaikan `onTokenRefresh`
* **Apa yang rusak bila diabaikan selama satu semester?**  
  Token FCM tidak bersifat permanen. Token dapat diperbarui oleh Google Play Services ketika aplikasi di-reinstall, melakukan pembaruan sistem, restore data, atau saat terjadi rotasi kunci keamanan internal FCM.
* **Dampaknya:**  
  Jika listener `onTokenRefresh` tidak diterapkan untuk mengunggah token baru ke backend, server kampus akan terus mengirimkan notifikasi push menggunakan token lama yang sudah kadaluarsa (*stale/invalid token*). Akibatnya, mahasiswa tidak akan menerima pengumuman penting kampus (seperti jadwal perkuliahan, pengumuman ujian, atau pembatalan kelas) selama sisa semester.

---

### 3. Penggunaan Topik vs Token Perangkat

| Kriteria | Topik (*Topic Messaging*) | Token Perangkat (*Device Token*) |
| :--- | :--- | :--- |
| **Kapan Digunakan** | Pengiriman pesan massal (*broadcast*) ke banyak pengguna yang memiliki minat atau kategori sama tanpa perlu melacak ID perangkat individual. | Pengiriman pesan spesifik/personal yang ditujukan hanya kepada satu pengguna atau satu perangkat tertentu. |
| **Contoh Pesan Kampus** | Pengumuman Libur Nasional, Informasi Edaran Rektorat, atau Berita Kegiatan Kampus untuk seluruh mahasiswa. | Notifikasi Pengingat Pembayaran UKM/SPP Personal, Peringatan Presensi Akademik Individu, atau Notifikasi Nilai Tugas. |

---

### 4. Evaluasi & Analisis Reflektif Terhadap Draf AI
Selama proses pengembangan dengan bantuan AI, terdapat beberapa saran draf kode yang **ditolak atau diperbaiki**:

1. **Sintaks Deprecated pada `flutter_local_notifications`**:  
   Draf awal AI memberikan kode `localNotif.initialize` dan `localNotif.show` menggunakan *positional arguments*. Kode tersebut ditolak dan diperbaiki ke sintaks terbaru yang mewajibkan *named arguments* (`settings:`, `id:`, `title:`, `body:`, `notificationDetails:`) untuk menghindari *compile error*.
2. **Penggunaan `StateProvider` pada Riverpod Modern**:  
   AI sempat menyarankan `StateProvider` untuk `authProvider`. Karena `StateProvider` sudah mulai ditinggalkan di versi Riverpod terbaru, kode diperbaiki menggunakan `NotifierProvider` dan class `AuthNotifier` agar arsitektur *state management* lebih stabil dan *future-proof*.
3. **Pengelolaan State Router GoRouter**:  
   Draf awal AI tidak mendengarkan perubahan `authProvider` secara reaktif pada `GoRouter`. Kode diperbaiki dengan membungkus `GoRouter` di dalam `routerProvider` dan menggunakan `ref.watch(authProvider)` agar proses *redirect* halaman login dan home berjalan otomatis saat tombol **Mock Login** ditekan.
