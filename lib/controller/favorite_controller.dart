import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/meal_model.dart';

class FavoriteController extends GetxController {
  // TODO (RESPONSI): Ganti nama variabel list dan tipe Model ini sesuai tema
  final RxList<MealModel> _favorites = <MealModel>[].obs;
  List<MealModel> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Key SharedPreferences per user
  Future<String> _getFavKey() async {
    final prefs = await SharedPreferences.getInstance();
    final String currentUser = prefs.getString('currentUser') ?? 'guest';
    // TODO (RESPONSI): Sesuaikan prefix nama key SharedPreferences favorit jika diperlukan
    return 'culinary_favorites_$currentUser';
  }

  // Load data favorit dari Local Storage (SharedPreferences)
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getFavKey();
    final String? rawData = prefs.getString(key);

    _favorites.clear();
    if (rawData != null && rawData.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(rawData);
        _favorites.assignAll(decoded.map((item) => MealModel.fromJson(item)).toList());
      } catch (e) {
        _favorites.clear();
      }
    }
  }

  // Simpan data favorit ke SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getFavKey();
    final String encoded = jsonEncode(_favorites.map((e) => e.toJson()).toList());
    await prefs.setString(key, encoded);
  }

  bool isFavorite(String id) {
    return _favorites.any((meal) => meal.id == id);
  }

  void toggleFavorite(MealModel meal) {
    if (isFavorite(meal.id)) {
      _favorites.removeWhere((item) => item.id == meal.id);
      _saveFavorites();
      Get.snackbar(
        'Dihapus dari Favorit',
        '${meal.name} telah dihapus dari daftar resep favorit.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade800,
        colorText: Colors.white,
        icon: const Icon(Icons.favorite_border, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    } else {
      _favorites.add(meal);
      _saveFavorites();
      Get.snackbar(
        'Ditambahkan ke Favorit',
        '${meal.name} berhasil disimpan ke daftar resep favorit!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.deepOrange,
        colorText: Colors.white,
        icon: const Icon(Icons.favorite, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void removeFavorite(MealModel meal) {
    _favorites.removeWhere((item) => item.id == meal.id);
    _saveFavorites();
    Get.snackbar(
      'Resep Dihapus',
      '${meal.name} telah dihapus dari daftar favorit.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      icon: const Icon(Icons.delete_outline, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
    );
  }

  // Reset state favorit (misal saat logout)
  void clearState() {
    _favorites.clear();
  }
}
