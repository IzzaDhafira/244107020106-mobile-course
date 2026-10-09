# Laporan Verifikasi & AI Challenge - Campus Notify

## 1. Prompt AI yang Digunakan
> Aplikasi Flutter Campus Notification App. Stack: firebase_messaging, flutter_local_notifications, flutter_secure_storage, go_router, Riverpod. Buatkan PushService dengan:
> - requestPermission + getToken + onTokenRefresh (kirim ke POST /devices)
> - onMessage (tampilkan local notification manual)
> - onMessageOpenedApp + getInitialMessage (navigasi ke data.route)
> - subscribe/unsubscribe topic pengumuman-kampus
> - background handler top-level dengan @pragma('vm:entry-point')
> Tandai bagian yang BERBEDA untuk Android 13+ vs iOS, dan bagian yang tidak boleh mengakses BuildContext.

---

## 2. Daftar Perbaikan Manual (Manual Bug Fixing)
Meskipun draf awal berhasil digenerate oleh AI, beberapa penyesuaian krusial dilakukan secara manual untuk memastikan aplikasi berjalan stabil:
* **Penanganan Klik Local Notification (Foreground)**: Draf AI awal hanya menyimpan *payload* ke variabel global tanpa memicu navigasi secara langsung. Diperbaiki secara manual dengan menambahkan *callback* `go(response.payload!)` pada konfigurasi `flutter_local_notifications`.
* **Penggunaan NavigatorKey**: Karena fungsi penanganan notifikasi berjalan di luar widget tree, pemanggilan `BuildContext` langsung menyebabkan error. Diperbaiki dengan mengimplementasikan `GlobalKey<NavigatorState>` agar navigasi GoRouter dapat dieksekusi secara aman dari luar.
* **Keamanan Token (Secrets)**: Memastikan token FCM yang dicetak untuk keperluan *debugging* tidak membawa data sensitif pengguna dan dibatasi hanya pada lingkungan pengembangan lokal.

---

## 3. Keputusan Teknis & Alasan
* **Top-Level Background Handler**: Fungsi `firebaseMessagingBackgroundHandler` wajib dibuat di luar kelas (*top-level*) dengan anotasi `@pragma('vm:entry-point')` karena dijalankan pada *isolate* terpisah oleh sistem Android saat aplikasi tertutup total. Sesuai aturan, fungsi ini **dilarang keras** mengakses `BuildContext` ataupun *state* Riverpod.
* **Pendekatan Hybrid (Data + Notification Payload)**: Menggunakan kombinasi pesan notifikasi sistem dan *data payload* (`route`) agar pesan otomatis tampil di latar belakang, sekaligus mampu membawa instruksi navigasi mendalam saat diklik oleh pengguna.

---

## 4. Matriks Pengujian Tiga App State
| State | Yang Diharapkan | Hasil Pengujian |
| :--- | :--- | :--- |
| **Foreground** | Banner lokal muncul, klik masuk ke `/pengumuman/3` | **Sukses**: Banner muncul di atas layar, saat diklik langsung mengarahkan aplikasi ke halaman detail ID 3. |
| **Background** | Banner sistem muncul, klik masuk ke rute yang benar | **Sukses**: Aplikasi di latar belakang (*minimize*), saat banner sistem diklik rute terbuka dengan benar. |
| **Terminated** | Aplikasi terbuka ke rute yang benar via `getInitialMessage` | **Sukses**: Aplikasi ditutup total (*swipe-close*), saat banner diklik aplikasi melakukan *cold start* menuju rute tujuan. |

## AI Verification Checklist & Temuan Teknis

1. **Apakah background handler berupa fungsi top-level dengan `@pragma('vm:entry-point')`?**
   * **Status**: Ya, terverifikasi.
   * **Temuan**: Fungsi `firebaseMessagingBackgroundHandler` dideklarasikan sebagai fungsi independen di luar kelas (*top-level*) dan diberi anotasi `@pragma('vm:entry-point')` agar dapat dieksekusi di *isolate* terpisah oleh sistem Android saat aplikasi tertutup total.

2. **Apakah `onTokenRefresh` benar-benar mengirim token baru ke backend, bukan hanya dicetak ke log?**
   * **Status**: Ya, terverifikasi.
   * **Temuan**: Pada implementasi `setupTokenHandling()`, fungsi `_fcm.onTokenRefresh` memanggil metode pengiriman ke server (`_sendTokenToServer`), yang dalam implementasi nyata disiapkan untuk melakukan HTTP POST ke endpoint backend.

3. **Apakah foreground memakai local notification manual?**
   * **Status**: Ya, terverifikasi.
   * **Temuan**: Blok `FirebaseMessaging.onMessage.listen` dikonfigurasikan menggunakan `flutter_local_notifications` (`_localNotificationsPlugin.show`) untuk memunculkan banner secara manual, karena sistem secara bawaan tidak menampilkan banner visual saat aplikasi aktif di *foreground*.

4. **Apakah klik dari ketiga state (foreground/background/terminated) masuk ke rute yang benar?**
   * **Status**: Ya, terverifikasi dan dibuktikan melalui pengujian.
   * **Temuan**: Berdasarkan pengujian menggunakan *payload* `/pengumuman/3`, ketiga state berhasil mengarahkan navigasi dengan tepat (menggunakan *callback* lokal, `onMessageOpenedApp`, dan `getInitialMessage`).

5. **Apakah token/secret tidak di-hardcode dan tidak di-log penuh?**
   * **Status**: Ya, aman.
   * **Temuan**: Tidak ada *hardcode* kunci rahasia. Token FCM yang didapat diambil secara dinamis dari instance perangkat dan pembatasan *logging* hanya dilakukan sebatas debugging lokal.

6. **Keputusan Final dan Alasan Teknis**
   * **Keputusan**: Memisahkan logika penanganan *payload* rute dan memanfaatkan `GlobalKey<NavigatorState>` untuk menghubungkan layanan *background/foreground* dengan GoRouter.
   * **Alasan Teknis**: Pemisahan ini dipilih agar arsitektur kode tetap bersih (*loosely coupled*), modular, serta menghindari *error* akibat akses `BuildContext` yang tidak valid di dalam *isolate* latar belakang.