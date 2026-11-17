import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/meal_model.dart';
import '../service/api_service.dart';

class MealController extends GetxController {
  // TODO (RESPONSI): Ganti tipe Model dan nama variabel list ini sesuai tema
  final RxList<MealModel> _meals = <MealModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Variabel penyaring (filter kategori, search, dan bonus sort)
  final RxString _selectedCategory = 'All'.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isAscending = false.obs; // Bonus 2: Sort A-Z

  List<MealModel> get meals => _meals;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;
  bool get isAscending => _isAscending.value;

  @override
  void onInit() {
    super.onInit();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final data = await ApiService.fetchMeals(
        category: _selectedCategory.value,
        name: _searchQuery.value,
      );

      // Terapkan sorting jika sedang aktif
      if (_isAscending.value) {
        data.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }

      _meals.assignAll(data);
    } catch (e) {
      _errorMessage.value = e.toString();
      _meals.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  void setCategoryFilter(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      _searchQuery.value = ''; // Reset pencarian jika ganti filter kategori
      fetchMeals();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    if (query.trim().isNotEmpty) {
      _selectedCategory.value = 'All'; // TheMealDB search bekerja global
    }
    fetchMeals();
  }

  // Bonus 2: Toggle Sort A-Z
  void toggleSort() {
    _isAscending.value = !_isAscending.value;
    if (_isAscending.value) {
      _meals.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      Get.snackbar(
        'Urutan A-Z',
        'Daftar resep diurutkan berdasarkan abjad (A ke Z).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.deepOrange,
        colorText: Colors.white,
        icon: const Icon(Icons.sort_by_alpha, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    } else {
      fetchMeals(); // Kembalikan ke urutan default API
      Get.snackbar(
        'Urutan Default',
        'Daftar resep dikembalikan ke urutan semula.',
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
