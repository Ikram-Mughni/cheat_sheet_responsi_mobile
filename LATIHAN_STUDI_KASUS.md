# 🍳 SOAL LATIHAN RESPONSI: Culinary Recipe Explorer (TheMealDB)

Buatlah aplikasi **Culinary Recipe Explorer**, yaitu aplikasi mobile berbasis Flutter untuk menjelajahi resep makanan dari seluruh dunia menggunakan API publik **TheMealDB**. 

Gunakan **Template Responsi Generic** yang telah disiapkan di proyek ini dan ikuti panduan pada file `PANDUAN_RESPONSI.md` dengan mencari tag `// TODO (RESPONSI):` untuk melakukan modifikasi.

---

## 📌 KETENTUAN FITUR APLIKASI

### 1. Halaman Autentikasi (Login & Register)
- [ ] Pengguna dapat mendaftar akun baru (Username & Password disimpan di **Hive Database**).
- [ ] Pengguna dapat masuk menggunakan akun yang telah didaftarkan.
- [ ] Status sesi login disimpan menggunakan **SharedPreferences** agar pengguna tidak perlu login ulang saat aplikasi dibuka kembali.
- [ ] Sediakan tombol **Logout** di AppBar dengan konfirmasi dialog untuk kembali ke halaman Login.

### 2. Halaman Utama (Home Screen / Katalog Resep)
- [ ] Tampilkan daftar resep makanan dari API menggunakan **Card** yang rapi.
- [ ] Setiap item kartu wajib menampilkan:
  - Foto makanan (`strMealThumb`)
  - Nama masakan (`strMeal`)
  - Kategori / Asal negara masakan (`strCategory` / `strArea`)
  - Tombol **Love / Favorit** interaktif (icon otomatis berubah warna saat diklik).
- [ ] **Fitur Pencarian:** Pengguna dapat mencari resep berdasarkan nama makanan (`search.php?s=...`).
- [ ] **Fitur Filter Kategori:** Sediakan Filter Chips pilihan kategori masakan (contoh: `All`, `Seafood`, `Chicken`, `Dessert`, `Beef`, `Vegetarian`).
- [ ] Tampilkan **Indikator Loading** saat data sedang diambil, **Pesan Error** dengan tombol *Coba Lagi* jika gagal, serta **Empty State** jika hasil pencarian kosong.
- [ ] Ketika item resep diklik, navigasikan pengguna ke **Halaman Detail Resep** via GetX Named Route.

### 3. Halaman Detail (Detail Screen)
- [ ] Tampilkan foto banner resep makanan di bagian atas layar.
- [ ] Tampilkan nama masakan, badge kategori, dan asal negara/daerah (`strArea`).
- [ ] Tampilkan instruksi cara memasak (`strInstructions`) di dalam Card informasi.
- [ ] Sediakan tombol **FloatingActionButton Favorit** untuk menambah/menghapus resep dari daftar favorit.
- [ ] Tampilkan **Get.snackbar** setiap kali status favorit diperbarui (icon dan teks harus sesuai).

### 4. Halaman Favorit (Favorite Screen)
- [ ] Simpan daftar resep favorit menggunakan **SharedPreferences** (format JSON serialization) agar data tetap tersimpan saat aplikasi ditutup.
- [ ] Pengguna dapat menghapus resep dari favorit dengan gestur **Swipe (Geser ke kiri / Dismissible)**.
- [ ] Tampilkan **Get.snackbar** konfirmasi setelah resep berhasil dihapus dari favorit.
- [ ] Tampilkan ilustrasi/pesan informatif apabila daftar favorit masih kosong.

### 5. Halaman Data Sekunder (Kategori Masakan / Categories Tab)
- [ ] Ambil dan tampilkan daftar kategori resep dari endpoint `categories.php`.
- [ ] Tampilkan nama kategori (`strCategory`), gambar thumbnail (`strCategoryThumb`), serta deskripsi singkatnya.

### 6. Navigasi & Tampilan
- [ ] Gunakan **Bottom Navigation Bar** untuk berpindah antara 3 menu:
  1. **Resep (Home)**
  2. **Favorit (Favorites)**
  3. **Kategori (Categories)**
- [ ] Gunakan state management dan routing terpusat **GetX** (`GetMaterialApp`, `AppRoutes`, `AppPages`, `Obx`, `Get.find()`).

---

## 🌐 DOKUMENTASI API YANG DIGUNAKAN

API ini **100% Gratis, Publik, dan Tanpa API Key (No Auth Required)**.

**Base URL:**  
`https://www.themealdb.com/api/json/v1/1`

### Daftar Endpoint:

| Kebutuhan Fitur | HTTP Method | Endpoint |
|---|---|---|
| **Daftar Resep & Pencarian** | `GET` | `/search.php?s={kata_kunci}` *(kosongkan parameter `s` untuk memuat semua resep default)* |
| **Filter berdasarkan Kategori** | `GET` | `/filter.php?c={kategori}` *(contoh: `/filter.php?c=Seafood`)* |
| **Detail Resep Lengkap** | `GET` | `/lookup.php?i={id_resep}` *(contoh: `/lookup.php?i=52772`)* |
| **Daftar Kategori (Data Sekunder)**| `GET` | `/categories.php` |

### Contoh Struktur JSON:

#### 1. Endpoint Resep (`/search.php?s=`):
```json
{
  "meals": [
    {
      "idMeal": "52772",
      "strMeal": "Teriyaki Chicken Casserole",
      "strCategory": "Chicken",
      "strArea": "Japanese",
      "strInstructions": "Preheat oven to 350° F. Spray a 9x13-inch baking dish with non-stick spray...",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg"
    }
  ]
}
```
> 💡 *Catatan:* Root objek dibungkus oleh key `"meals"`. Jika data tidak ditemukan, API akan mengembalikan `{"meals": null}`.

#### 2. Endpoint Kategori (`/categories.php`):
```json
{
  "categories": [
    {
      "idCategory": "1",
      "strCategory": "Beef",
      "strCategoryThumb": "https://www.themealdb.com/images/category/beef.png",
      "strCategoryDescription": "Beef is the culinary name for meat from cattle..."
    }
  ]
}
```
> 💡 *Catatan:* Root objek dibungkus oleh key `"categories"`.

---

## 🛠️ PANDUAN LANGKAH MODIFIKASI (MENGGUNAKAN TEMPLATE)

Ikuti urutan kerja dari file `PANDUAN_RESPONSI.md`:

1. **`lib/model/`:**
   - Ubah `character_model.dart` menjadi model Resep (misal: `MealModel`) dengan field: `idMeal`, `strMeal`, `strCategory`, `strArea`, `strInstructions`, `strMealThumb`.
   - Ubah `episode_model.dart` menjadi model Kategori (misal: `CategoryModel`) dengan field: `idCategory`, `strCategory`, `strCategoryThumb`, `strCategoryDescription`.
2. **`lib/service/`:**
   - Update `_baseUrl` di `api_service.dart` ke `https://www.themealdb.com/api/json/v1/1`.
   - Sesuaikan fungsi get ke `/search.php?s=...`, filter kategori ke `/filter.php?c=...`, dan kategori ke `/categories.php`.
   - Perhatikan fallback jika `data['meals'] == null` maka kembalikan list kosong `[]`.
3. **`lib/controller/`:**
   - Sesuaikan `CharacterController` dan `FavoriteController` agar mengelola `MealModel`.
   - Sesuaikan `EpisodeController` agar mengelola `CategoryModel`.
4. **`lib/view/widgets/` & `lib/view/pages/`:**
   - Di `character_card.dart`: hubungkan `character.name` ➡️ `meal.strMeal`, `character.image` ➡️ `meal.strMealThumb`.
   - Di `home_page.dart`: ganti list filter chip menjadi `['All', 'Seafood', 'Chicken', 'Beef', 'Dessert', 'Vegetarian']`.
   - Di `detail_page.dart`: tampilkan `strMealThumb`, `strMeal`, `strCategory`, `strArea`, dan `strInstructions`.
   - Di `episode_page.dart`: tampilkan thumbnail kategori, nama kategori, dan deskripsi kategori.
   - Di `root_page.dart`: ganti label BottomNavigationBar menjadi: **Resep**, **Favorit**, dan **Kategori**.

---

## 🌟 TANTANGAN TAMBAHAN (BONUS NILAI RESPONSI)

- [ ] **Bonus 1 (Tema Warna Kuliner):**  
  Ubah tema aplikasi di `lib/main.dart` agar bernuansa kuliner/restoran, misalnya menggunakan warna dasar Oranye/Amber hangat (`Colors.deepOrange` atau `Colors.amber.shade800`).
- [ ] **Bonus 2 (Fitur Sort A-Z):**  
  Tambahkan sebuah tombol icon di AppBar `HomePage` untuk mengurutkan daftar resep secara alfabetis (A ➡️ Z).
