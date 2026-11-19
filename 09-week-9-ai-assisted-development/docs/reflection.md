# Refleksi AI-Assisted Development (Week 9)

## 1. Satu halusinasi AI apa yang Anda temukan dan bagaimana membuktikannya?
- **Temuan:** Pada iterasi awal, AI menyisipkan *import* `sqflite` langsung ke lapisan *domain/widget* serta membuat pencarian bersifat *case-sensitive* tanpa `.toLowerCase()`. Selain itu, saat *review*, AI menyarankan penambahan package eksternal `rxdart` untuk *debounce* pencarian list lokal yang sebenarnya tidak dibutuhkan.
- **Pembuktian:** Dibuktikan melalui perintah pencarian string (`grep`) pada folder `domain/` untuk mendeteksi *import* lintas layer, serta pembuatan skenario *unit test* merah dengan input huruf kapital/spasi (`'  BELANJA '`) yang awalnya gagal sebelum diperbaiki.

## 2. Prompt mana yang paling membantu dan apa yang Anda ubah?
- **Prompt paling membantu:** Prompt dengan **Formula 5 Slot** (Peran, Konteks, Tugas, Batas, Output) dan prompt **AI Code Review** yang membatasi fokus hanya pada *kebenaran, arsitektur, dan test* serta mengabaikan *style*.
- **Perubahan yang dilakukan:** Mempertegas bagian **Batas** agar AI tidak menyentuh struktur folder arsitektur, melarang *import* Flutter/SQLite di `domain/`, dan membatasi panjang fungsi maksimal 40 baris.

## 3. Satu refactor apa yang Anda lakukan pada kode AI?
- **Refactor:** Memindahkan seluruh logika penyaringan daftar catatan dari dalam *state* widget `NoteSearchPage` ke kelas *use case* murni `FilterNotes` di `lib/features/notes/domain/usecases/filter_notes.dart`, serta menambahkan normalisasi `.trim().toLowerCase()`.
- **Dampak:** Widget UI menjadi jauh lebih bersih karena hanya bertugas merender tampilan dan *empty state*, sementara logika pencarian dapat diuji secara terisolasi lewat *unit test* cepat tanpa merender UI.

## 4. Keputusan terima/tolak mana yang paling sulit?
- **Keputusan:** Menolak saran penambahan *debounce timer* menggunakan package eksternal (`rxdart`) pada input pencarian.
- **Alasan:** Secara sekilas saran tersebut terdengar seperti *best practice* performa, namun setelah dianalisis sesuai konteks proyek, daftar catatan sudah dimuat di memori lokal (*in-memory list*), sehingga penambahan dependensi eksternal hanya akan menambah kompleksitas yang tidak perlu.