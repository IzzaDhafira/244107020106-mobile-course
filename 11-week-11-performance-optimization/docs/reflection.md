# Refleksi Performance Optimization (Week 11)

## 1. Optimasi mana yang memberikan dampak terbesar dan mengapa?
Penggunaan **`ListView.builder` yang dikombinasikan dengan `itemExtent` dan ekstraksi widget `const`** memberikan dampak terbesar. Teknik ini memangkas jumlah widget yang dibangun sekaligus pada awal render dari ratusan item menjadi hanya sekitar 8–10 item yang muat di layar, sehingga beban UI Thread turun drastis.

## 2. Bagaimana Anda memverifikasi bahwa optimasi benar-benar bekerja (bukan placebo)?
Verifikasi dilakukan dengan membandingkan rekaman **Flame Chart** dan **Frame Time** di Flutter DevTools pada mode `--profile` menggunakan skenario interaksi yang sama persis (*scroll* cepat + pencarian) sebelum dan sesudah perubahan, serta memastikan *unit test* tetap lulus.

## 3. Trade-off apa yang Anda hadapi (misalnya kompleksitas kode vs performa)?
Penambahan *in-memory query cache* pada `FilterNotes` mempercepat pencarian berulang, namun menambah sedikit penggunaan memori RAM dan membutuhkan disiplin untuk membersihkan *cache* (`clearCache()`) ketika data catatan ditambah atau diubah agar tidak terjadi data usang (*stale data*).

## 4. Kapan sebaiknya optimasi premature dihindari?
Optimasi kompleks (seperti *caching* manual berlapis atau `RepaintBoundary` di setiap sudut UI) sebaiknya dihindari pada tahap awal prototyping atau ketika daftar data masih sangat sedikit (< 20 item) dan hasil *profiling* menunjukkan *frame time* masih aman di bawah 16 ms. Optimasi harus selalu didasarkan pada bukti *bottleneck* dari DevTools.