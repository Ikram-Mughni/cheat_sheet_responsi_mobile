# 📋 SOP & CHECKLIST PANDUAN CEPAT RESPONSI FLUTTER

Dokumen ini adalah panduan langkah-demi-langkah (SOP) untuk mengubah **Template Responsi Generic** ini secara cepat dan tepat ketika Anda menghadapi soal ujian dengan studi kasus API yang baru (misal: Film, Berita, Resep Makanan, Cuaca, Buku, dll).

> 💡 **Trik Cepat di VS Code:**  
> Tekan **`Ctrl + Shift + F`** lalu cari kata kunci:  
> `TODO (RESPONSI)`  
> Ini akan menampilkan seluruh titik kode yang wajib Anda sesuaikan satu per satu!

---

## 🎯 ALUR KERJA (WORKFLOW) UTAMA

```
[Tahap 1: Analisis API] 
        ⬇️
[Tahap 2: lib/model/] 
        ⬇️
[Tahap 3: lib/service/] 
        ⬇️
[Tahap 4: lib/controller/] 
        ⬇️
[Tahap 5: lib/view/] 
        ⬇️
[Tahap 6: Local Storage / Hive & SP] 
```

---

## 🔍 TAHAP 1: Analisis API (Postman / Browser)

Sebelum mengetik kode Flutter, pastikan Anda telah menguji endpoint API di Browser atau Postman:

- [ ] **1. Catat Base URL & Endpoint:**
  - Base URL (contoh: `https://api.themoviedb.org/3` atau `https://newsapi.org/v2`)
  - Endpoint Utama (contoh: `/movie/popular`, `/v2/top-headlines`, `/character`)
  - Endpoint Detail / Filter / Search jika ada (contoh: `?category=technology`, `?query=batman`)
- [ ] **2. Periksa Struktur Response JSON:**
  - Apakah root JSON berupa **Map `{ ... }`** dengan pembungkus list (misal: `results: [...]` atau `data: [...]` atau `products: [...]`)?
  - Atau root JSON **langsung berupa List `[ ... ]`**?
- [ ] **3. Catat Key & Tipe Data Atribut Utama:**
  - ID / Identifier: `int` atau `String`?
  - Nama / Judul: key `name` atau `title`?
  - Gambar / Poster: key `image`, `poster_path`, atau `thumbnail`?
  - Angka / Harga / Rating: `price`, `vote_average` (wajib konversi aman ke `num` / `double`).

---

## 📦 TAHAP 2: Eksekusi `lib/model/`

Buka file model di folder `lib/model/` (misal: `character_model.dart`):

- [ ] **1. Sesuaikan Deklarasi Atribut:**
  - Ganti/tambahkan variabel class sesuai JSON yang dibutuhkan di soal.
  - *Best practice:* Gunakan tipe data non-nullable dengan nilai default fallback di constructor.
- [ ] **2. Sesuaikan Mapping `factory fromJson`:**
  - Cocokkan nama key string (`json['...']`) dengan struktur API.
  - **Type-safety angka (PENTING agar tidak crash):**
    ```dart
    id: (json['id'] as num?)?.toInt() ?? 0,
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    ```
  - **Fallback Null-safety:**
    ```dart
    title: json['title'] ?? '',
    images: json['images'] ?? [],
    ```
- [ ] **3. Sesuaikan Mapping `toJson`:**
  - Pastikan method `toJson()` mengembalikan `Map<String, dynamic>` dengan key yang sama jika objek model ini akan disimpan ke `SharedPreferences` (Fitur Favorit).
- [ ] **4. Model Sekunder (Jika Ada):**
  - Jika soal meminta list sekunder (misal: `Episode`, `Review`, `Author`), sesuaikan juga file `episode_model.dart`.

---

## 🌐 TAHAP 3: Eksekusi `lib/service/`

Buka file `lib/service/api_service.dart`:

- [ ] **1. Ganti Base URL:**
  ```dart
  static const String _baseUrl = 'https://api-soal-baru.com/api';
  ```
- [ ] **2. Sesuaikan Fungsi Fetch Data Utama (`fetchCharacters` / `fetchMovies`):**
  - Ganti path endpoint (misal: `Uri.parse('$_baseUrl/character')` diubah sesuai endpoint soal).
  - Sesuaikan query parameters filter dan search (misal: `queryParams['category'] = ...`, `queryParams['search'] = ...`).
- [ ] **3. Sesuaikan Pembongkaran JSON di Blok `if (response.statusCode == 200)`:**
  - **Jika response dibungkus key:**
    ```dart
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> results = data['results'] ?? []; // ganti 'results' sesuai key API
    return results.map((item) => CharacterModel.fromJson(item)).toList();
    ```
  - **Jika response langsung List:**
    ```dart
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => CharacterModel.fromJson(item)).toList();
    ```
- [ ] **4. Sesuaikan Fungsi Fetch Data Sekunder (Jika Ada):**
  - Update endpoint dan parsing untuk fungsi kedua (misal: `fetchEpisodes` / `fetchReviews`).

---

## 🎮 TAHAP 4: Eksekusi `lib/controller/`

Buka folder `lib/controller/`:

- [ ] **1. `character_controller.dart`:**
  - Sesuaikan nama variabel dan tipe list jika mengganti nama Model:
    ```dart
    final RxList<CharacterModel> _characters = <CharacterModel>[].obs;
    ```
  - Sesuaikan parameter fungsi `fetchCharacters()` agar sinkron dengan argumen query di `ApiService`.
  - Sesuaikan method `setStatusFilter` dan `setSearchQuery` sesuai kebutuhan filter/search pada soal.
- [ ] **2. `favorite_controller.dart`:**
  - Pastikan list favorit menggunakan model yang sama:
    ```dart
    final RxList<CharacterModel> _favorites = <CharacterModel>[].obs;
    ```
  - Sesuaikan ID unik objek pada pengecekan:
    ```dart
    bool isFavorite(int id) => _favorites.any((item) => item.id == id);
    ```
  - Sesuaikan pesan teks pada `Get.snackbar` saat item berhasil ditambah/dihapus dari favorit.
- [ ] **3. `episode_controller.dart` (Jika Ada):**
  - Sesuaikan list reaktif dan pemanggilan service untuk data sekunder.

---

## 🖼️ TAHAP 5: Eksekusi `lib/view/` (Pages & Widgets)

Buka folder `lib/view/`:

### A. Widget Kartu (`lib/view/widgets/character_card.dart`)
- [ ] Ganti pemanggilan gambar thumbnail: `Image.network(character.image)` -> sesuaikan dengan atribut gambar model baru.
- [ ] Ganti pemanggilan teks judul utama: `Text(character.name)`.
- [ ] Ganti pemanggilan teks subtitle & info ketiga: (misal: harga, status, kategori, atau rating).
- [ ] Sesuaikan passing ID ke `favController.isFavorite(character.id)`.

### B. Halaman Utama (`lib/view/pages/home_page.dart`)
- [ ] Ubah daftar opsi Filter Chips:
  ```dart
  final statusList = ['All', 'Category 1', 'Category 2', 'Category 3'];
  ```
- [ ] Ganti teks hint search bar:
  ```dart
  hintText: 'Cari data...', // Misal: 'Cari judul film...', 'Cari buku...'
  ```
- [ ] Sesuaikan pesan saat data tidak ditemukan (*empty state*).

### C. Halaman Detail (`lib/view/pages/detail_page.dart`)
- [ ] Pastikan casting model Get.arguments sesuai:
  ```dart
  final CharacterModel character = Get.arguments as CharacterModel;
  ```
- [ ] Ganti banner gambar utama di bagian atas.
- [ ] Ganti teks judul dan badge status/kategori.
- [ ] Sesuaikan baris-baris informasi pada tabel/kartu `_buildDetailRow(Icon, Label, Value)`.

### D. Halaman Favorit (`lib/view/pages/favorite_page.dart`)
- [ ] Sesuaikan key unik pada widget `Dismissible`:
  ```dart
  key: Key('fav_${character.id}'),
  ```
- [ ] Sesuaikan thumbnail gambar, judul, dan subtitle pada `ListTile` item favorit.

### E. Halaman Sekunder (`lib/view/pages/episode_page.dart`)
- [ ] Sesuaikan pemanggilan data sekunder (judul, tanggal/subtitle, dan badge kode).

### F. Halaman Navigasi & Autentikasi
- [ ] **`root_page.dart`:** Sesuaikan label dan icon pada `BottomNavigationBar` (misal: Beranda, Favorit, Episode/Reviews).
- [ ] **`login_page.dart` & `register_page.dart`:** Sesuaikan nama aplikasi dan judul form jika ada instruksi khusus.
- [ ] **`main.dart`:** Ganti `title` aplikasi dan atur `seedColor` jika ingin nuansa warna berbeda.

---

## 💾 TAHAP 6: Penyesuaian Local Storage (Hive & SP)

### A. SharedPreferences (Session Login & Favorit)
- Fitur session login dan penyimpanan favorit berbasis JSON sudah otomatis berjalan.
- Cukup pastikan method `toJson()` dan `fromJson()` pada model data yang difavoritkan sudah benar.

### B. Hive (Database Lokal)
- Penggunaan default di template ini menggunakan `Hive.openBox('usersBox')` untuk menyimpan akun user (username & password).
- **PENTING (Jika Soal Mewajibkan Model Hive Baru):**
  1. Tambahkan anotasi pada model:
     ```dart
     import 'package:hive/hive.dart';
     part 'todo.g.dart';

     @HiveType(typeId: 0) // Pastikan typeId unik (0, 1, 2, dst.)
     class Todo extends HiveObject {
       @HiveField(0)
       final String title;
       @HiveField(1)
       final String subtitle;
       ...
     }
     ```
  2. Jalankan build runner di terminal:
     ```bash
     dart run build_runner build
     ```
  3. Daftarkan adapter dan buka box di `main.dart` sebelum `runApp()`:
     ```dart
     Hive.registerAdapter(TodoAdapter());
     await Hive.openBox<Todo>('todos');
     ```

---

## 🚨 CHECKLIST ERROR-PREVENTION SEBELUM KUMPULKAN

- [ ] Tidak ada garis merah (*compile error*) di seluruh file.
- [ ] Fungsi Search berjalan (tekan enter atau klik tombol 'Cari').
- [ ] Filter Chips dapat diklik dan data berganti sesuai filter.
- [ ] Navigasi Home ➡️ Detail berhasil dan data detail tampil lengkap.
- [ ] Fitur Tambah/Hapus Favorit berfungsi dan icon hati reaktif berubah warna.
- [ ] Halaman Favorit menampilkan data yang disimpan (tidak hilang saat back/pindah tab).
- [ ] Fitur Swipe-to-delete pada Halaman Favorit berfungsi dan memunculkan SnackBar.
- [ ] Register user baru berhasil, data tersimpan di Hive, dan bisa login menggunakan akun tersebut.
- [ ] Tombol Logout di AppBar memunculkan dialog konfirmasi dan berhasil kembali ke halaman Login.
