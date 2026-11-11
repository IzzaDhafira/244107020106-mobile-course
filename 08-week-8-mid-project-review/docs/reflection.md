# Refleksi Mid-Project Review (Week 8)

Dokumen ini berisi jawaban refleksi terkait proses kolaborasi, peninjauan kode (*peer review*), penggunaan AI, serta evaluasi teknis selama paruh pertama semester.

## 1. Apa beda LGTM buta dengan approve yang bertanggung jawab? Apa risikonya bagi tim?
- **Perbedaan:** *LGTM (Looks Good To Me) buta* adalah tindakan menyetujui Pull Request secara asal tanpa benar-benar membaca, mengecek, atau menguji kodenya terlebih dahulu. Sebaliknya, *approve yang bertanggung jawab* melibatkan peninjauan mendalam terhadap logika, arsitektur, dan eksekusi tes mesin (`analyze` & `test`).
- **Risiko bagi tim:** Bug atau error bisa lolos ke branch utama (`develop`/`main`), merusak aturan arsitektur kode (*dependency rule*), dan menurunkan tingkat kepercayaan antar anggota tim.

## 2. Kapan komentar wajib berstatus request changes, dan kapan cukup saran?
- **Request Changes:** Wajib digunakan jika ditemukan pelanggaran aturan utama, bug kritis, kesalahan logika (*edge case* yang gagal), atau pelanggaran arsitektur (*Clean Architecture*) yang dapat merusak sistem jika digabungkan.
- **Cukup Saran (Suggestion):** Digunakan jika kode sudah berfungsi dengan baik dan aman, namun hanya memerlukan peningkatan minor pada kerapian atau keterbacaan kode yang tidak memengaruhi fungsionalitas.

## 3. Bagian mana dari review AI yang Anda tolak atau sederhanakan, dan mengapa?
- **Bagian yang ditolak:** Saran AI terkait pengecekan *null-pointer* manual yang bersifat redundan pada State Notifier serta koreksi *style* minor.
- **Alasan:** Manajemen *state async* dari Riverpod sudah menangani status data dengan aman secara *native*, dan urusan pemformatan gaya kode diserahkan sepenuhnya kepada otomatisasi mesin (`dart format` dan linter CI).

## 4. Satu hal konkret yang Anda perbaiki setelah review sejawat — apa dampaknya?
- **Perbaikan:** Penerapan validasi judul kosong yang terisolasi dengan baik di lapisan *use case* serta penambahan unit test pengujiannya.
- **Dampaknya:** Aplikasi menjadi lebih andal, terhindar dari penyimpanan data kosong yang tidak valid secara arsitektural, dan memastikan setiap perubahan perilaku kode terjamin aman oleh pengujian otomatis.