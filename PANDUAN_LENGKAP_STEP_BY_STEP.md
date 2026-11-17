# 🧭 PANDUAN LENGKAP STEP-BY-STEP: Mengubah Template Responsi ke Studi Kasus Baru

> **Santai, jangan panik!**  
> Saat kamu mendapatkan lembar soal responsi baru dengan tema yang berbeda (misalnya dari film, anime, cuaca, makanan, atau toko online), **kuncinya adalah jangan mengedit file secara acak**.  
> Cukup ikuti **urutan 6 langkah** di bawah ini dari awal sampai akhir secara bertahap.

---

## 💡 Konsep Dasar (Pahami Alur Ini Dulu)

Aplikasi Flutter kita bekerja dengan alur seperti ini:
```
[1. Internet / API Server] 
         ⬇️ (Data mentah JSON diambil oleh Service)
[2. Service: api_service.dart]
         ⬇️ (Data diubah menjadi objek cetakan oleh Model)
[3. Model: ..._model.dart]
         ⬇️ (Data disimpan & dikelola oleh Controller)
[4. Controller: ..._controller.dart]
         ⬇️ (Data ditampilkan ke mata pengguna)
[5. Tampilan Layar: view/pages/ & view/widgets/]
```
**Karena alurnya dari atas ke bawah, maka cara mengodingnya juga harus dari NOMOR 1 ke NOMOR 5!**

---

## 🏁 STEP 0: Bedah Soal & Buka API di Browser (Waktu: 3 Menit)

Saat lembar soal responsi dibagikan:
1. **Cari Link API-nya.** Biasanya tertulis jelas di soal.  
   *Contoh:* `https://hp-api.onrender.com/api/characters`
2. **Copy link tersebut dan paste ke browser (Chrome).**  
   Tekan Enter dan lihat apa yang muncul di layar:
   * **Bentuk Kurung:**
     * Jika diawali kurung siku `[` berarti itu langsung berupa **List / Daftar item**.
     * Jika diawali kurung kurawal `{` berarti itu dibungkus **Map / Objek** (biasanya datanya ada di dalam key `"results"`, `"data"`, atau `"meals"`).
   * **Pilih 4 sampai 6 data penting yang ingin ditampilkan:**
     * Mana ID uniknya? (biasanya `id`, `idMeal`, `mal_id`)
     * Mana nama/judul utamanya? (biasanya `name`, `title`, `strMeal`)
     * Mana fotonya? (biasanya `image`, `poster`, `picture`, `strMealThumb`)
     * Mana kategorinya? (biasanya `category`, `house`, `status`, `genre`)
     * Mana deskripsi/detailnya? (biasanya `description`, `synopsis`, `instructions`)

---

## 🧱 STEP 1: Buat Cetakan Data di Folder `lib/model/` (Waktu: 5 Menit)

Model adalah "cetakan" agar Flutter tahu tipe data apa saja yang dimiliki tiap item.

### Yang Harus Dilakukan:
1. Buka folder `lib/model/`.
2. Ubah file `character_model.dart` menjadi model barumu (misal: `wizard_model.dart` / `movie_model.dart`).
3. Tuliskan variabelnya:
```dart
class WizardModel {
  final String id;
  final String name;
  final String house;
  final String image;

  WizardModel({
    required this.id,
    required this.name,
    required this.house,
    required this.image,
  });

  // Bagian membaca JSON dari internet (fromJson)
  // TIPS: Beri fallback '??' agar TIDAK PERNAH error null-safety!
  factory WizardModel.fromJson(Map<String, dynamic> json) {
    return WizardModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Tanpa Nama',
      house: json['house']?.toString() ?? 'Umum',
      image: json['image']?.toString() ?? '',
    );
  }

  // Bagian menyimpan ke Local Storage Favorit (toJson)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'house': house,
      'image': image,
    };
  }
}
```

> ⚠️ **Trik Anti-Error di Model:**
> Selalu tambahkan `?.toString() ?? ''` di belakang setiap `json['nama_key']`.  
> Tujuannya: Jika dari server nilainya `null` atau tipenya angka/huruf acak, aplikasi **TIDAK AKAN CRASH**!

---

## 🌐 STEP 2: Atur Penarikan Data di `lib/service/api_service.dart` (Waktu: 5 Menit)

Service bertugas seperti kurir yang menembak URL ke internet lalu membawa pulang datanya.

### Yang Harus Diubah:
1. **Ganti `_baseUrl`** dengan alamat pangkal domain API soal:
   ```dart
   static const String _baseUrl = 'https://hp-api.onrender.com/api';
   ```
2. **Ganti Fungsi Pemanggilan Data (`fetch...`):**
   ```dart
   static Future<List<WizardModel>> fetchWizards({String? house, String? name}) async {
     try {
       // Buat URL endpoint-nya
       final uri = Uri.parse('$_baseUrl/characters');
       final response = await http.get(uri);

       if (response.statusCode == 200) {
         // KASUS A: Jika JSON langsung berupa kurung siku [ ... ]
         final List<dynamic> list = jsonDecode(response.body);
         return list.map((e) => WizardModel.fromJson(e)).toList();

         // KASUS B: Jika JSON dibungkus map { "results": [ ... ] }
         // final Map<String, dynamic> data = jsonDecode(response.body);
         // final List<dynamic> list = data['results'] ?? [];
         // return list.map((e) => WizardModel.fromJson(e)).toList();
       } else {
         throw Exception('Gagal mengambil data dari server');
       }
     } catch (e) {
       throw Exception('Terjadi kesalahan koneksi: $e');
     }
   }
   ```

---

## 🧠 STEP 3: Atur Otak Data di Folder `lib/controller/` (Waktu: 7 Menit)

Controller bertugas menyimpan data dari Service ke variabel reaktif (`RxList`, `RxBool`) agar UI otomatis ter-update saat data selesai diunduh.

### 1. Di Controller Utama (`wizard_controller.dart`):
* Ganti tipe list:
  ```dart
  final RxList<WizardModel> _wizards = <WizardModel>[].obs;
  List<WizardModel> get wizards => _wizards;
  ```
* Ganti method `fetchWizards()`:
  ```dart
  Future<void> fetchWizards() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final data = await ApiService.fetchWizards(house: _selectedHouse.value);
      _wizards.assignAll(data);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }
  ```
* Ganti fungsi filter/search:
  ```dart
  void setHouseFilter(String house) {
    _selectedHouse.value = house;
    fetchWizards();
  }
  ```

### 2. Di `favorite_controller.dart`:
* Ganti `CharacterModel` menjadi `WizardModel`:
  ```dart
  final RxList<WizardModel> _favorites = <WizardModel>[].obs;
  ```
* Ganti parameter tipe ID di `isFavorite`:
  * Jika ID-nya angka: `bool isFavorite(int id)`
  * Jika ID-nya huruf/string: `bool isFavorite(String id)`
* Ganti method `toggleFavorite(WizardModel item)` dan `removeFavorite(WizardModel item)`.
* Ganti nama key SharedPreferences agar tidak bertabrakan:
  ```dart
  return 'favorites_app_$currentUser';
  ```

---

## 🃏 STEP 4: Bikin Kartu Item di `lib/view/widgets/` (Waktu: 5 Menit)

Buka `wizard_card.dart` (sebelumnya `character_card.dart`).  
Widget ini adalah bentuk satuan kartu yang muncul berulang-ulang di daftar utama.

### Yang Harus Dihubungkan:
* Parameter kartu: `final WizardModel wizard;`
* Fotonya:
  ```dart
  Image.network(
    wizard.image,
    width: 70, height: 70, fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
  )
  ```
* Judulnya: `Text(wizard.name)`
* Subjudulnya: `Text(wizard.house)`
* Tombol Love:
  ```dart
  Obx(() {
    final isFav = favController.isFavorite(wizard.id);
    return IconButton(
      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
      color: isFav ? Colors.red : Colors.grey,
      onPressed: () => favController.toggleFavorite(wizard),
    );
  })
  ```

---

## 📱 STEP 5: Pasang Layar Tampilan di `lib/view/pages/` (Waktu: 10 Menit)

Sekarang tinggal pasang widget tadi ke dalam halaman layar:

### 1. `home_page.dart`:
* **Filter Chips:** Ganti opsi list chip sesuai kategori dari soal:
  ```dart
  final houseList = ['All', 'Gryffindor', 'Slytherin', 'Hufflepuff', 'Ravenclaw'];
  ```
* **ListView:** Pasang kartu yang sudah dibuat di Step 4:
  ```dart
  itemBuilder: (context, index) {
    final wizard = controller.wizards[index];
    return WizardCard(
      wizard: wizard,
      onTap: () {
        Get.toNamed(AppRoutes.detail, arguments: wizard); // Kirim data ke detail
      },
    );
  }
  ```

### 2. `detail_page.dart`:
* **Terima datanya:**
  ```dart
  final WizardModel wizard = Get.arguments as WizardModel;
  ```
* Tampilkan fotonya di banner atas: `Image.network(wizard.image)`
* Tampilkan nama & keterangannya di teks dan card.
* Tombol FloatingActionButton di bawah layar untuk tombol favorit:
  ```dart
  floatingActionButton: Obx(() {
    final isFav = favController.isFavorite(wizard.id);
    return FloatingActionButton.extended(
      onPressed: () => favController.toggleFavorite(wizard),
      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
      label: Text(isFav ? 'Hapus Favorit' : 'Tambah Favorit'),
    );
  })
  ```

### 3. `favorite_page.dart`:
* Ganti casting item favorit menjadi:
  ```dart
  final wizard = favController.favorites[index];
  ```
* Pastikan `Dismissible` memakai key: `Key('fav_${wizard.id}')`.

### 4. `root_page.dart`:
* Sesuaikan icon & tulisan di `BottomNavigationBar`:
  * Tab 1: **Katalog / Beranda**
  * Tab 2: **Favorit**
  * Tab 3: **Data Sekunder** (misal: Mantra, Kategori, atau Info)

---

## 🔗 STEP 6: Hubungkan Semuanya di `routes/app_pages.dart` & `main.dart` (Waktu: 2 Menit)

Ini langkah terakhir agar aplikasi tidak error *"Controller not found"*:

1. Buka `lib/routes/app_pages.dart`.
2. Di dalam class `RootBinding`, pastikan controller barumu sudah didaftarkan dengan `lazyPut`:
   ```dart
   class RootBinding extends Bindings {
     @override
     void dependencies() {
       Get.lazyPut<AuthController>(() => AuthController());
       Get.lazyPut<RootController>(() => RootController());
       Get.lazyPut<WizardController>(() => WizardController()); // Controller Barumu!
       Get.lazyPut<FavoriteController>(() => FavoriteController());
     }
   }
   ```
3. Buka `lib/main.dart`:
   * Ganti judul aplikasi: `title: 'Nama Aplikasi Baru'`
   * Ganti tema warna di `colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)` agar sesuai dengan tema soal.

---

## 🆘 KAMUS CEPAT: Mengatasi Error yang Sering Bikin Panik Saat Responsi

| Pesan Error di Debug Console | Penyebabnya | Solusi Cepat |
|---|---|---|
| **`"XController" not found`** | Lupa mendaftarkan controller | Buka `lib/routes/app_pages.dart`, tambahkan `Get.lazyPut(() => XController());` di `RootBinding`. |
| **`type 'List<dynamic>' is not a subtype of type 'Map'`** | Salah cara decode JSON | Di `api_service.dart`, ganti `jsonDecode(res.body)` langsung menjadi `List<dynamic>`, jangan pakai `Map<String, dynamic>`. |
| **`Null check operator used on a null value`** | Ada data dari API yang null | Buka Model, pastikan semua mapping memakai `?? ''` atau `?? 0`. Jangan gunakan tanda seru `!`. |
| **`ClientException: Failed to fetch`** | Masalah CORS di browser Web | Coba jalankan di Emulator Android atau gunakan fallback link mirror. |
| **Data di layar tidak berubah saat diklik** | Lupa dibungkus `Obx` | Bungkus widget yang ingin berubah dengan `Obx(() => ... )`. |

---

## ⏱️ Rekomendasi Alokasi Waktu Ujian (Total: 40-50 Menit)
* **Menit 01 - 05:** Baca soal, buka link API di Chrome, catat nama-nama key JSON.
* **Menit 05 - 12:** Buat `lib/model/` (lengkap dengan `fromJson` & `toJson`).
* **Menit 12 - 20:** Buat `lib/service/api_service.dart` (tes print datanya keluar atau belum).
* **Menit 20 - 30:** Atur `lib/controller/` (`RxList`, fetch, filter, favorit).
* **Menit 30 - 45:** Pasang ke UI (`widgets/` dan `pages/`).
* **Menit 45 - 50:** Rapikan `main.dart`, cek fitur Favorit & Logout. Selesai! 🎉
