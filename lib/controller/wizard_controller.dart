import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/wizard_model.dart'; // TERUBAH: Import WizardModel menggantikan CharacterModel
import '../service/api_service.dart';

class WizardController extends GetxController {
  // TERUBAH: Mengganti tipe data RxList menjadi RxList<WizardModel> dan nama variabel menjadi _wizards
  final RxList<WizardModel> _wizards = <WizardModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // TERUBAH: Mengganti filter status menjadi filter asrama Hogwarts (_selectedHouse)
  final RxString _selectedHouse = 'All'.obs;
  final RxString _searchQuery = ''.obs;
  // TERUBAH: Menambahkan variabel reaktif untuk Bonus 2: Urutan A-Z
  final RxBool _isAscending = false.obs;

  List<WizardModel> get wizards => _wizards; // TERUBAH: Getter wizards
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get selectedHouse => _selectedHouse.value; // TERUBAH: Getter selectedHouse
  String get searchQuery => _searchQuery.value;
  bool get isAscending => _isAscending.value; // TERUBAH: Getter isAscending

  @override
  void onInit() {
    super.onInit();
    fetchWizards(); // TERUBAH: Inisialisasi pemanggilan data penyihir
  }

  // TERUBAH: Method fetchWizards menggantikan fetchCharacters
  Future<void> fetchWizards() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // TERUBAH: Memanggil ApiService.fetchWizards dengan parameter house dan nama pencarian
      final data = await ApiService.fetchWizards(
        house: _selectedHouse.value,
        name: _searchQuery.value,
      );

      // TERUBAH: Menerapkan fitur urutan A-Z jika status isAscending aktif
      if (_isAscending.value) {
        data.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }

      _wizards.assignAll(data);
    } catch (e) {
      _errorMessage.value = e.toString();
      _wizards.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  // TERUBAH: Method setHouseFilter menggantikan setStatusFilter
  void setHouseFilter(String house) {
    if (_selectedHouse.value != house) {
      _selectedHouse.value = house;
      fetchWizards(); // TERUBAH: Memuat ulang data berdasarkan asrama terpilih
    }
  }

  // TERUBAH: Method setSearchQuery untuk memfilter karakter berdasarkan nama
  void setSearchQuery(String query) {
    _searchQuery.value = query;
    fetchWizards();
  }

  // TERUBAH: Bonus 2 - Method toggleSort untuk mengurutkan daftar penyihir dari A ke Z
  void toggleSort() {
    _isAscending.value = !_isAscending.value;
    if (_isAscending.value) {
      _wizards.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      Get.snackbar(
        'Urutan A-Z',
        'Daftar penyihir diurutkan dari A ke Z.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.deepPurple,
        colorText: Colors.white,
        icon: const Icon(Icons.sort_by_alpha, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    } else {
      fetchWizards(); // Kembalikan ke urutan default
      Get.snackbar(
        'Urutan Default',
        'Daftar penyihir dikembalikan ke urutan semula.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade800,
        colorText: Colors.white,
        icon: const Icon(Icons.restore, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
