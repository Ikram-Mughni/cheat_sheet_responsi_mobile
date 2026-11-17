# 🛍️ SOAL LATIHAN RESPONSI 3: E-Commerce Product Catalog (DummyJSON)

Buatlah aplikasi **E-Commerce Product Catalog**, yaitu aplikasi mobile berbasis Flutter untuk menjelajahi katalog produk toko online, mencari barang, melihat detail harga dan spesifikasi, serta menyimpan produk favorit menggunakan API publik **DummyJSON Products**.

Gunakan **Template Responsi Generic** yang telah disiapkan di proyek ini dan ikuti panduan pada file `PANDUAN_LENGKAP_STEP_BY_STEP.md` untuk memodifikasi kode secara terstruktur.

---

## 🌐 DOKUMENTASI API (100% STABIL & BEBAS CORS)

API ini **100% Gratis, Tanpa API Key, Sangat Cepat (Cloudflare CDN), dan Mendukung CORS 100%** (dijamin tidak akan ada error `Failed to fetch` saat dibuka di browser Chrome).

* **Buka & Cek Langsung di Chrome:**  
  👉 `https://dummyjson.com/products`

* **Base URL:**  
  `https://dummyjson.com`

### Daftar Endpoint:

| Kebutuhan Fitur | HTTP Method | Endpoint Lengkap | Keterangan |
|---|---|---|---|
| **Daftar Semua Produk** | `GET` | `https://dummyjson.com/products` | Mengambil seluruh katalog produk |
| **Pencarian Produk** | `GET` | `https://dummyjson.com/products/search?q={kata_kunci}` | Contoh: `.../search?q=phone` |
| **Filter berdasarkan Kategori** | `GET` | `https://dummyjson.com/products/category/{kategori}` | Contoh: `.../category/beauty` atau `.../category/smartphones` |
| **Daftar Kategori (Tab 3)** | `GET` | `https://dummyjson.com/products/categories` | Mengambil list kategori produk |

---

## 📋 CONTOH RESPONSE JSON & PEMETAAN MODEL

### 1. Data Produk (`/products`):
```json
{
  "products": [
    {
      "id": 1,
      "title": "Essence Mascara Lash Princess",
      "description": "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects.",
      "category": "beauty",
      "price": 9.99,
      "discountPercentage": 7.17,
      "rating": 4.94,
      "stock": 5,
      "brand": "Essence",
      "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png"
    }
  ],
  "total": 194,
  "skip": 0,
  "limit": 30
}
```

> 💡 **PENTING (Struktur JSON):**  
> Seperti Rick & Morty API, root data dibungkus oleh key `"products"`.  
> Cara decode di Service:
> ```dart
> final Map<String, dynamic> data = jsonDecode(response.body);
> final List<dynamic> list = data['products'] ?? [];
> return list.map((item) => ProductModel.fromJson(item)).toList();
> ```

#### Tabel Pemetaan Model Produk (`ProductModel`):
| Properti Class | Tipe Data | Key JSON | Catatan Fallback Aman |
|---|---|---|---|
| `id` | `int` | `json['id']` | `(json['id'] as num?)?.toInt() ?? 0` |
| `title` | `String` | `json['title']` | `json['title']?.toString() ?? 'Tanpa Nama'` |
| `description` | `String` | `json['description']` | `json['description']?.toString() ?? '-'` |
| `category` | `String` | `json['category']` | `json['category']?.toString() ?? 'General'` |
| `price` | `double` | `json['price']` | `(json['price'] as num?)?.toDouble() ?? 0.0` |
| `rating` | `double` | `json['rating']` | `(json['rating'] as num?)?.toDouble() ?? 0.0` |
| `brand` | `String` | `json['brand']` | `json['brand']?.toString() ?? 'No Brand'` |
| `thumbnail` | `String` | `json['thumbnail']` | `json['thumbnail']?.toString() ?? ''` |

---

### 2. Data Kategori Produk (`/products/categories` - Tab Ke-3):
```json
[
  {
    "slug": "beauty",
    "name": "Beauty",
    "url": "https://dummyjson.com/products/category/beauty"
  },
  {
    "slug": "fragrances",
    "name": "Fragrances",
    "url": "https://dummyjson.com/products/category/fragrances"
  },
  {
    "slug": "furniture",
    "name": "Furniture",
    "url": "https://dummyjson.com/products/category/furniture"
  }
]
```

> 💡 **Catatan:** Endpoint kategori mengembalikan **JSON List langsung `[...]`**.

#### Tabel Pemetaan Model Kategori (`CategoryModel`):
| Properti Class | Tipe Data | Key JSON | Catatan Fallback |
|---|---|---|---|
| `slug` | `String` | `json['slug']` | Identifier kategori untuk filter |
| `name` | `String` | `json['name']` | Nama label kategori |

---

## 📌 KETENTUAN FITUR APLIKASI (STANDAR RESPONSI)

### 1. Halaman Autentikasi (Login & Register)
- [ ] Pengguna dapat mendaftar akun baru (Username & Password disimpan di **Hive Database**).
- [ ] Pengguna dapat masuk menggunakan akun yang telah didaftarkan.
- [ ] Sesi login disimpan menggunakan **SharedPreferences** (`isLoggedIn: true`).
- [ ] Sediakan tombol **Logout** di AppBar dengan dialog konfirmasi.

### 2. Halaman Utama (Home Screen / Katalog Produk)
- [ ] Tampilkan daftar produk menggunakan **Card** yang rapi.
- [ ] Setiap item kartu wajib menampilkan:
  - Foto produk (`thumbnail`)
  - Nama produk (`title`)
  - Kategori produk (`category`)
  - Harga produk dalam format mata uang (contoh: `\$${product.price}`)
  - Rating bintang (`rating`)
  - Tombol **Love / Favorit** interaktif (icon otomatis berubah warna saat diklik).
- [ ] **Fitur Pencarian:** Cari produk berdasarkan kata kunci nama produk (`/products/search?q=...`).
- [ ] **Fitur Filter Kategori:** Sediakan Filter Chips pilihan kategori:
  - `['All', 'beauty', 'fragrances', 'furniture', 'groceries', 'smartphones']`
- [ ] Tampilkan **Indikator Loading**, **Pesan Error**, dan **Empty State** jika produk tidak ditemukan.
- [ ] Ketika item produk diklik, navigasikan ke **Halaman Detail** via GetX Named Route.

### 3. Halaman Detail (Detail Screen)
- [ ] Tampilkan foto banner produk di bagian atas layar.
- [ ] Tampilkan judul produk, badge kategori, dan harga produk yang menonjol.
- [ ] Tampilkan informasi rinci di dalam Card: Brand, Rating Bintang, dan Deskripsi lengkap produk.
- [ ] Sediakan tombol **FloatingActionButton Favorit** untuk menambah/menghapus produk dari daftar favorit.
- [ ] Tampilkan **Get.snackbar** setiap kali status favorit diperbarui.

### 4. Halaman Favorit (Favorite Screen)
- [ ] Simpan daftar produk favorit menggunakan **SharedPreferences** (format JSON serialization per-user, key: `ecommerce_favorites_$currentUser`).
- [ ] Pengguna dapat menghapus produk dari favorit dengan gestur **Swipe (Geser ke kiri / Dismissible)**.
- [ ] Tampilkan **Get.snackbar** konfirmasi setelah produk berhasil dihapus.
- [ ] Tampilkan ilustrasi/pesan informatif apabila daftar favorit masih kosong.

### 5. Halaman Data Sekunder (Kategori Produk / Categories Tab)
- [ ] Ambil dan tampilkan daftar kategori dari endpoint `/products/categories`.
- [ ] Tampilkan nama kategori dengan icon rapi di ListView.
- [ ] Dukung fitur *Pull to Refresh* (`RefreshIndicator`).

### 6. Navigasi & Tampilan
- [ ] Gunakan **Bottom Navigation Bar** untuk berpindah antara 3 menu:
  1. **Produk** (`Icons.shopping_bag_outlined` / `Icons.shopping_bag`)
  2. **Favorit** (`Icons.favorite_border` / `Icons.favorite`)
  3. **Kategori** (`Icons.category_outlined` / `Icons.category`)
- [ ] Gunakan state management dan routing terpusat **GetX**.

---

## 🛠️ CHECKLIST LANGKAH PENGERJAAN CEPAT (SOP)

Ikuti panduan pada file `PANDUAN_LENGKAP_STEP_BY_STEP.md`:

1. **`lib/model/`:**
   - Buat `product_model.dart` dengan field: `id`, `title`, `description`, `category`, `price`, `rating`, `brand`, `thumbnail`. Lengkapi `fromJson` dan `toJson`.
   - Buat `category_model.dart` dengan field: `slug`, `name`.
2. **`lib/service/api_service.dart`:**
   - Atur `_baseUrl = 'https://dummyjson.com'`.
   - Buat `fetchProducts({String? category, String? query})`:
     - Jika ada query: `$_baseUrl/products/search?q=$query`
     - Jika ada category ('All' diabaikan): `$_baseUrl/products/category/$category`
     - Default: `$_baseUrl/products`
   - Buat `fetchCategories()`: panggil `$_baseUrl/products/categories`.
3. **`lib/controller/`:**
   - Buat `ProductController` (`RxList<ProductModel> _products`, search, filter, sort).
   - Sesuaikan `FavoriteController` (`RxList<ProductModel> _favorites`, key: `ecommerce_favorites_$currentUser`).
   - Buat `CategoryController` (`RxList<CategoryModel> _categories`).
4. **`lib/view/widgets/` & `lib/view/pages/`:**
   - Buat `product_card.dart`.
   - Update `home_page.dart`, `detail_page.dart`, `favorite_page.dart`, dan `category_page.dart`.
   - Update `root_page.dart` (3 tab: Produk, Favorit, Kategori).
5. **`lib/routes/app_pages.dart` & `lib/main.dart`:**
   - Daftarkan `ProductController`, `FavoriteController`, `CategoryController` di `RootBinding`.
   - Atur tema di `main.dart` menjadi warna elegan toko online (`Colors.teal` atau `Colors.indigo`).

---

## 🌟 TANTANGAN TAMBAHAN (BONUS NILAI RESPONSI)

- [ ] **Bonus 1 (Tema Warna Toko Online):**  
  Gunakan tema warna **Teal / Emerald** modern (`seedColor: Colors.teal` atau `Color(0xFF00897B)`).
- [ ] **Bonus 2 (Fitur Sortir Harga atau A-Z):**  
  Tambahkan tombol sort di AppBar `HomePage` untuk mengurutkan produk berdasarkan harga terendah ke tertinggi atau abjad nama A-Z.
