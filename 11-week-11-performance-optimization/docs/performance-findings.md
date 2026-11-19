# Temuan Baseline Profiling (Week 11)

Berdasarkan pengamatan pada Flutter DevTools (tab Performance & Memory) sebelum optimasi:
1. **Widget Rebuild Berlebih:** Saat pengguna mengetik pada `TextField` pencarian, seluruh elemen daftar dan ikon statis ikut dieksekusi ulang (`build` berulang di Flame Chart) karena belum menggunakan `const` constructor dan ekstraksi widget kecil.
2. **Layout & Raster Cost saat Scroll Cepat:** Daftar panjang yang tidak menggunakan `ListView.builder` dengan `itemExtent` menyebabkan lonjakan waktu `Layout` pada UI Thread dan `Raster` Thread saat melakukan *fast scroll*.
3. **Komputasi Filter Berulang & Potensi Memory Leak:** Penyaringan daftar berulang kali menghitung ulang kueri yang sama tanpa mekanisme *cache*, serta `TextEditingController` berpotensi menahan memori jika tidak dibersihkan melalui `dispose()` saat navigasi bolak-balik.