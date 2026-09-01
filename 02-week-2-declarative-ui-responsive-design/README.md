# Laporan Praktikum Minggu 2: Declarative UI & Responsive Design

**Identitas Mahasiswa**
* **Nama:** Izza Dhafira Fanani
* **NIM:** 244107020106
* **Kelas:** TI-3D
* **Program Studi:** D-IV Teknik Informatika

---

## Bagian 1: AI Prompt Challenge

### 1. Perbandingan Tata Letak
* **GridView:** 
  Lebih mudah diimplementasikan untuk galeri homogen dan ringan secara performa. Namun, hierarkinya kaku sehingga sulit menyisipkan header non-grid (seperti profil), serta membuat alur navigasi pembaca layar (screen reader) kurang terstruktur.
* **LayoutBuilder + Column:**
  Memberikan fleksibilitas absolut. LayoutBuilder memungkinkan deteksi batas lebar layar (maxWidth) untuk mengubah jumlah kolom secara dinamis (misal: 1 kolom di bawah 700px, 2 kolom di atasnya), sementara Column memudahkan integrasi header dan navigasi logis bagi pengguna disabilitas.
* **Keputusan:** Menggunakan **LayoutBuilder + Column** agar struktur Academic Overview lebih fleksibel dan ramah aksesibilitas.

### 2. Penguatan Konsep
* **Analisis Masalah:** Expanded bertugas mengambil sisa ruang yang ada. Jika diletakkan di dalam Row yang berada di dalam pembungkus horizontal tak terhingga (seperti SingleChildScrollView dengan arah horizontal), mesin Flutter gagal mengkalkulasi batas akhirnya sehingga memicu error RenderFlex unbounded.
* **Solusi:** Menghapus pembungkus scroll horizontal agar dimensi Row terikat kuat pada batas lebar layar, sehingga teks panjang di dalam Expanded dapat membungkus baris dengan aman.

### 3. Verifikasi AI
* **Risiko Vertical Overflow:** Penggunaan rasio aspek statis pada GridView rentan membuat teks tumpah di layar mobile sempit atau saat pengaturan teks sistem diperbesar.
* **Polusi Aksesibilitas (Double Reading):** Widget Semantics pada kartu sebelumnya dieja dua kali oleh pembaca layar. 
* **Perbaikan:** Menambahkan parameter excludeSemantics: true pada widget Semantics pembungkus kartu agar mesin murni hanya membaca label kustom yang telah dioptimalkan.

---

## Bagian 2: Implementasi, Refactoring, & Pengujian

### 1. Implementasi & Refactoring Kode
* **Ekstraksi Widget (`InfoCard`):** Kartu informasi diekstrak menjadi komponen modular (*reusable*) yang menerima parameter `title`, `value`, dan `icon` untuk menghindari duplikasi kode.
* **Penerapan Theme M3:** Menggunakan `Theme.of(context)` agar warna otomatis menyesuaikan saat toggle mode terang dan gelap ditekan secara dinamis.
* **Konstanta Breakpoint:** Menggunakan konstanta global `kWideBreakpoint = 700` untuk menentukan batas responsivitas layar.

### 2. Hasil Pengujian (Testing & Analyze)
* **Flutter Analyze:** Kode bersih tanpa ada error maupun warning.
`![Hasil Flutter Analyze](screenshots/hasil_flutter_analyze.png)`

* **Flutter Test:** Pengujian otomatis menggunakan override ukuran layar (Size(400, 800) dan Size(1200, 800) dengan penambahan selektor .first) berhasil lulus 100%.
`![Hasil Flutter Test](screenshots/hasil_flutter_test.png)`

### 3. Bukti Tangkapan Layar (Screenshots)
* **Tampilan Layar Sempit (1 Kolom):**
  `![Mobile View](screenshots/refactoring_light_mobile.jpeg)`

* **Tampilan Layar Lebar (2 Kolom):**
  `![Tablet View](screenshots/refactoring_light_tablet.jpeg)`