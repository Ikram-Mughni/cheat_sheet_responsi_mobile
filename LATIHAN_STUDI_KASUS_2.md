# ⚡ SOAL LATIHAN RESPONSI 2: Hogwarts Wizarding Explorer (Harry Potter API)

Buatlah aplikasi **Hogwarts Wizarding Explorer**, yaitu aplikasi mobile berbasis Flutter untuk menjelajahi profil karakter penyihir, asrama (*house*), dan mantra (*spells*) dari dunia sihir menggunakan API publik **Harry Potter API (HP-API)**.

Gunakan **Template Responsi Generic** yang telah disiapkan di proyek ini dan ikuti panduan pada file `PANDUAN_RESPONSI.md` dengan mencari tag `// TODO (RESPONSI):` untuk melakukan modifikasi secara cepat dan terarah.

---

## 📌 KETENTUAN FITUR APLIKASI

### 1. Halaman Autentikasi (Login & Register)
- [ ] Pengguna dapat mendaftar akun baru (Username & Password disimpan di **Hive Database**).
- [ ] Pengguna dapat masuk menggunakan akun yang telah didaftarkan.
- [ ] Status sesi login disimpan menggunakan **SharedPreferences** (`isLoggedIn: true`) agar pengguna tidak perlu login ulang saat aplikasi dibuka kembali.
- [ ] Sediakan tombol **Logout** di AppBar dengan konfirmasi dialog untuk keluar dan menghapus sesi.

### 2. Halaman Utama (Home Screen / Karakter Penyihir)
- [ ] Tampilkan daftar karakter penyihir dari API menggunakan **Card** yang rapi.
- [ ] Setiap item kartu wajib menampilkan:
  - Foto karakter (`image`) — berikan fallback icon/placeholder jika string `image` kosong.
  - Nama karakter (`name`)
  - Asrama / House (`house`) dan Spesies (`species`)
  - Status hidup/mati (`alive`) atau Patronus (`patronus`)
  - Tombol **Love / Favorit** interaktif (icon otomatis berubah warna merah/aktif saat ditekan).
- [ ] **Fitur Pencarian:** Pengguna dapat mencari karakter berdasarkan nama (contoh: *Harry*, *Hermione*, *Draco*).
- [ ] **Fitur Filter Asrama (House):** Sediakan Filter Chips pilihan asrama:
  - `All`, `Gryffindor`, `Slytherin`, `Hufflepuff`, `Ravenclaw`.
- [ ] Tampilkan **Indikator Loading** saat data sedang diambil, **Pesan Error** dengan tombol *Coba Lagi* jika gagal, serta **Empty State** jika hasil pencarian kosong.
- [ ] Ketika item karakter diklik, navigasikan pengguna ke **Halaman Detail** via GetX Named Route dengan membawa argumen objek data.

### 3. Halaman Detail (Detail Screen)
- [ ] Tampilkan foto banner karakter di bagian atas layar.
- [ ] Tampilkan nama karakter, badge asrama (*House*), dan badge status (*Alive / Deceased*).
- [ ] Tampilkan informasi rinci di dalam Card:
  - Asrama (*House*)
  - Spesies (*Species*)
  - Aktor pemeran (*Actor*)
  - Patronus (*Patronus*)
  - Tanggal Lahir (*Date of Birth*)
- [ ] Sediakan tombol **FloatingActionButton Favorit** untuk menambah/menghapus karakter dari daftar favorit.
- [ ] Tampilkan **Get.snackbar** setiap kali status favorit diperbarui (icon dan teks harus sesuai).

### 4. Halaman Favorit (Favorite Screen)
- [ ] Simpan daftar karakter favorit menggunakan **SharedPreferences** (format JSON serialization per-user, key: `hogwarts_favorites_$currentUser`).
- [ ] Pengguna dapat menghapus karakter dari favorit dengan gestur **Swipe (Geser ke kiri / Dismissible)**.
- [ ] Tampilkan **Get.snackbar** konfirmasi setelah karakter berhasil dihapus.
- [ ] Tampilkan ilustrasi/pesan informatif apabila daftar favorit masih kosong.

### 5. Halaman Data Sekunder (Mantra Sihir / Spells Tab)
- [ ] Ambil dan tampilkan daftar mantra sihir dari endpoint `/spells`.
- [ ] Tampilkan nama mantra (`name`) dan deskripsi fungsinya (`description`) dalam bentuk Card/ListTile yang rapi.
- [ ] Dukung fitur *Pull to Refresh* (`RefreshIndicator`).

### 6. Navigasi & Tampilan
- [ ] Gunakan **Bottom Navigation Bar** untuk berpindah antara 3 menu:
  1. **Penyihir (Characters)**
  2. **Favorit (Favorites)**
  3. **Mantra (Spells)**
- [ ] Gunakan state management dan routing terpusat **GetX** (`GetMaterialApp`, `AppRoutes`, `AppPages`, `Obx`, `Get.find()`).

---

## 🌐 DOKUMENTASI API YANG DIGUNAKAN

API ini **100% Gratis, Publik, Cepat, dan Tanpa API Key**.

**Base URL:**  
`https://hp-api.onrender.com/api`

### Daftar Endpoint:

| Kebutuhan Fitur | HTTP Method | Endpoint | Keterangan |
|---|---|---|---|
| **Semua Karakter** | `GET` | `/characters` | Mengambil seluruh daftar karakter penyihir |
| **Filter Asrama (House)** | `GET` | `/characters/house/{house}` | Contoh: `/characters/house/gryffindor`, `/characters/house/slytherin` |
| **Daftar Siswa Hogwarts** | `GET` | `/characters/students` | Karakter yang berstatus murid |
| **Daftar Mantra (Tab 3)** | `GET` | `/spells` | Mengambil daftar mantra sihir untuk data sekunder |

> 💡 **PENTING (Struktur JSON):**  
> Berbeda dari API lain yang membungkus datanya dalam object Map (seperti `{"results": [...]}`), HP-API langsung mengembalikan data dalam bentuk **JSON Array (List)** di level root (`[...]`).  
> Maka cara decode di Service adalah:  
> ```dart
> final List<dynamic> list = jsonDecode(response.body);
> return list.map((item) => WizardModel.fromJson(item)).toList();
> ```

---

## 📋 CONTOH RESPONSE JSON & PEMETAAN FIELD

### 1. Data Karakter (`/characters` atau `/characters/house/gryffindor`):
```json
[
  {
    "id": "9e3f7ce4-b9a7-4b44-b303-f663797b9cc6",
    "name": "Harry Potter",
    "alternate_names": [
      "The Boy Who Lived",
      "The Chosen One"
    ],
    "species": "human",
    "gender": "male",
    "house": "Gryffindor",
    "dateOfBirth": "31-07-1980",
    "yearOfBirth": 1980,
    "wizard": true,
    "ancestry": "half-blood",
    "eyeColour": "green",
    "hairColour": "black",
    "wand": {
      "wood": "holly",
      "core": "phoenix feather",
      "length": 11
    },
    "patronus": "stag",
    "hogwartsStudent": true,
    "hogwartsStaff": false,
    "actor": "Daniel Radcliffe",
    "alternate_actors": [],
    "alive": true,
    "image": "https://ik.imagekit.io/hpapi/harry.jpg"
  }
]
```

#### Tabel Pemetaan Model Karakter (`WizardModel`):
| Properti Class | Tipe Data | Key JSON | Catatan / Fallback |
|---|---|---|---|
| `id` | `String` | `json['id']` | ID unik (UUID string) |
| `name` | `String` | `json['name']` | Nama lengkap karakter |
| `house` | `String` | `json['house']` | `json['house']?.toString() ?? 'No House'` |
| `species` | `String` | `json['species']` | `json['species']?.toString() ?? 'Unknown'` |
| `actor` | `String` | `json['actor']` | `json['actor']?.toString() ?? 'Unknown Actor'` |
| `patronus` | `String` | `json['patronus']` | `json['patronus']?.toString() ?? 'None'` |
| `dateOfBirth` | `String` | `json['dateOfBirth']` | `json['dateOfBirth']?.toString() ?? '-'` |
| `alive` | `bool` | `json['alive']` | `json['alive'] ?? true` |
| `image` | `String` | `json['image']` | String URL gambar (jika kosong `""`, gunakan foto fallback) |

---

### 2. Data Mantra Sihir (`/spells` - Untuk Tab Ke-3):
```json
[
  {
    "id": "b3046f56-6a59-4d69-a1b7-b089c2fa7c06",
    "name": "Aberto",
    "description": "Opens doors"
  },
  {
    "id": "e305e94b-1428-444a-9efb-9ae287e0fa1a",
    "name": "Accio",
    "description": "Summons an object"
  },
  {
    "id": "f5eef141-8f55-46f1-be80-e8220678d46a",
    "name": "Alohomora",
    "description": "Unlocks doors and objects"
  }
]
```

#### Tabel Pemetaan Model Mantra (`SpellModel`):
| Properti Class | Tipe Data | Key JSON | Catatan / Fallback |
|---|---|---|---|
| `id` | `String` | `json['id']` | ID unik mantra |
| `name` | `String` | `json['name']` | Nama mantra sihir |
| `description` | `String` | `json['description']` | Penjelasan fungsi mantra |

---

## 🛠️ CHECKLIST LANGKAH PENGERJAAN (SOP RESPONSI)

Ikuti urutan langkah di bawah ini untuk menyelesaikan modifikasi:

### Langkah 1: Model (`lib/model/`)
- [ ] Buat file `lib/model/wizard_model.dart`:
  - Masukkan properti: `id`, `name`, `house`, `species`, `actor`, `patronus`, `dateOfBirth`, `alive`, `image`.
  - Buat constructor, factory `fromJson`, dan method `toJson` (untuk SharedPreferences favorit).
- [ ] Buat file `lib/model/spell_model.dart`:
  - Masukkan properti: `id`, `name`, `description`.
  - Buat constructor, factory `fromJson`, dan method `toJson`.

### Langkah 2: Service (`lib/service/api_service.dart`)
- [ ] Ubah `_baseUrl` menjadi `'https://hp-api.onrender.com/api'`.
- [ ] Buat fungsi `fetchWizards({String? house})`:
  - Jika `house != null && house != 'All'`, panggil `'$_baseUrl/characters/house/${house.toLowerCase()}'`.
  - Jika tidak, panggil `'$_baseUrl/characters'`.
  - Decode response body sebagai `List<dynamic>` dan map ke `WizardModel`.
- [ ] Buat fungsi `fetchSpells()`:
  - Panggil `'$_baseUrl/spells'`.
  - Decode response body sebagai `List<dynamic>` dan map ke `SpellModel`.

### Langkah 3: Controller (`lib/controller/`)
- [ ] Buat `lib/controller/wizard_controller.dart`:
  - Variabel reaktif: `RxList<WizardModel> _wizards`, `RxBool _isLoading`, `RxString _errorMessage`, `RxString _selectedHouse = 'All'.obs`, `RxString _searchQuery = ''.obs`.
  - Tambahkan fungsi filter asrama (`setHouseFilter`) dan fungsi pencarian client-side (`searchQuery` menyaring nama yang mengandung kata kunci).
- [ ] Update `lib/controller/favorite_controller.dart`:
  - Kelola `RxList<WizardModel> _favorites`.
  - Simpan dengan key `hogwarts_favorites_$currentUser`.
  - Method `isFavorite(String id)`, `toggleFavorite(WizardModel wizard)`, `removeFavorite(WizardModel wizard)`.
- [ ] Buat `lib/controller/spell_controller.dart`:
  - Kelola `RxList<SpellModel> _spells` dari `ApiService.fetchSpells()`.

### Langkah 4: View & Widgets (`lib/view/`)
- [ ] Buat `lib/view/widgets/wizard_card.dart`:
  - Tampilkan foto (`image` dengan penanganan fallback jika string kosong).
  - Tampilkan nama penyihir, asrama, dan status *alive*.
  - Icon favorit reaktif `Obx`.
- [ ] Update `lib/view/pages/home_page.dart`:
  - Filter chips: `['All', 'Gryffindor', 'Slytherin', 'Hufflepuff', 'Ravenclaw']`.
  - Search bar untuk mencari nama penyihir.
  - ListView menampilkan `WizardCard`.
- [ ] Update `lib/view/pages/detail_page.dart`:
  - Tampilkan foto banner, badge asrama, status alive, aktor, dan tanggal lahir.
  - FloatingActionButton untuk simpan ke favorit + `Get.snackbar`.
- [ ] Update `lib/view/pages/favorite_page.dart`:
  - Menampilkan daftar karakter favorit dengan `Dismissible` swipe-to-delete.
- [ ] Buat `lib/view/pages/spell_page.dart`:
  - Menampilkan daftar mantra sihir (`name` & `description`) dengan `ListTile`/`Card`.
- [ ] Update `lib/view/pages/root_page.dart`:
  - Tab 1: **Penyihir** (`Icons.auto_awesome_outlined` / `Icons.auto_awesome`)
  - Tab 2: **Favorit** (`Icons.favorite_border` / `Icons.favorite`)
  - Tab 3: **Mantra** (`Icons.menu_book_outlined` / `Icons.menu_book`)

### Langkah 5: Binding & Theme (`lib/routes/app_pages.dart` & `lib/main.dart`)
- [ ] Daftarkan `WizardController`, `FavoriteController`, dan `SpellController` di `RootBinding`.
- [ ] Di `main.dart`, sesuaikan judul aplikasi (`'Hogwarts Wizarding Explorer'`).

---

## 🌟 TANTANGAN TAMBAHAN (BONUS NILAI RESPONSI)

- [ ] **Bonus 1 (Tema Warna Hogwarts / Gryffindor):**  
  Ubah tema di `lib/main.dart` menjadi warna ungu mistis atau merah maroon khas Gryffindor:
  - Opsi 1 (Deep Purple): `seedColor: Colors.deepPurple`
  - Opsi 2 (Gryffindor Maroon): `seedColor: Color(0xFF740001)` dan aksen emas `Color(0xFFEEBA30)`.
- [ ] **Bonus 2 (Fitur Sort A-Z):**  
  Tambahkan tombol sort di AppBar atau header list untuk mengurutkan nama penyihir secara alfabetis (A ➡️ Z).
