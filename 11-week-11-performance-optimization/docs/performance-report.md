# Performance Optimization Report (Week 11)

## 1. Baseline Metrics (Before Optimization)
- **Target Target Frame Budget (60fps):** `< 16.6 ms` per frame
- **Rata-rata Frame Time (UI / Raster):** `22.4 ms` (UI) / `19.8 ms` (Raster) saat *fast scroll* 500 item
- **Jank Count (Frame Merah/Kuning):** 14 frame jank terdeteksi pada skenario *scroll* + pencarian
- **Memory Usage (Heap):** 68.4 MB (cenderung naik +3.2 MB setelah 5x navigasi bolak-balik)

## 2. Bukti Profiling (Flame Chart)
- **Before:** `screenshots/before-profile.png`
- **After:** `screenshots/after-profile.png`

## 3. Optimasi yang Diterapkan & Alasan Pemilihan
1. **`ListView.builder` + `itemExtent: 76`:** Memastikan hanya item yang terlihat di viewport yang dibangun, serta menghilangkan kalkulasi tinggi item dinamis saat scroll.
2. **Ekstraksi Widget Kecil (`_NoteCardTile`) + `const` Constructor:** Mengisolasi widget kartu catatan dan elemen statis (`Icon`, `InputDecoration`, `Text`) agar dilewati oleh fase *rebuild* Flutter.
3. **`RepaintBoundary` pada Item List:** Mencegah efek *repaint* merambat ke seluruh daftar ketika salah satu baris berinteraksi.
4. **In-Memory Query Cache & `dispose()` Controller:** Menyimpan hasil pencarian ke dalam `Map` pada `FilterNotes` agar pencarian kueri berulang berjalan dalam $O(1)$, serta memanggil `_searchController.dispose()` untuk mencegah *memory leak*.

## 4. Hasil Verifikasi (Metrics After)
- **Rata-rata Frame Time (UI / Raster):** `8.1 ms` (UI) / `7.4 ms` (Raster) — turun >60% dan stabil di bawah batas `16.6 ms`
- **Jank Count:** 0 frame merah, 1 frame kuning ringan saat inisialisasi awal
- **Memory Usage (Heap):** Stabil di kisaran `64.1 MB` tanpa akumulasi objek setelah 5x navigasi ulang