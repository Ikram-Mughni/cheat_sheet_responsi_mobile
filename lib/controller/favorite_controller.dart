import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/character_model.dart';

class FavoriteController extends GetxController {
  // TODO (RESPONSI): Ganti nama variabel list dan tipe Model ini sesuai tema (misal: RxList<MovieModel> _favorites = <MovieModel>[].obs;).
  final RxList<CharacterModel> _favorites = <CharacterModel>[].obs;
  List<CharacterModel> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Key SharedPreferences per user
  Future<String> _getFavKey() async {
    final prefs = await SharedPreferences.getInstance();
    final String currentUser = prefs.getString('currentUser') ?? 'guest';
    // TODO (RESPONSI): Sesuaikan prefix nama key SharedPreferences favorit jika diperlukan.
    return 'app_favorites_$currentUser';
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
        // TODO (RESPONSI): Pastikan fromJson pada model digunakan untuk deserialize data lokal.
        _favorites.assignAll(decoded.map((item) => CharacterModel.fromJson(item)).toList());
      } catch (e) {
        _favorites.clear();
      }
    }
  }

  // Simpan data favorit ke SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getFavKey();
    // TODO (RESPONSI): Pastikan toJson() tersedia pada model untuk serialisasi JSON.
    final String encoded = jsonEncode(_favorites.map((e) => e.toJson()).toList());
    await prefs.setString(key, encoded);
  }

  bool isFavorite(int id) {
    return _favorites.any((character) => character.id == id);
  }

  void toggleFavorite(CharacterModel character) {
    if (isFavorite(character.id)) {
      _favorites.removeWhere((item) => item.id == character.id);
      _saveFavorites();
      // TODO (RESPONSI): Sesuaikan teks notifikasi SnackBar jika diperlukan.
      Get.snackbar(
        'Dihapus dari Favorit',
        '${character.name} telah dihapus dari daftar favorit.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade800,
        colorText: Colors.white,
        icon: const Icon(Icons.favorite_border, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    } else {
      _favorites.add(character);
      _saveFavorites();
      // TODO (RESPONSI): Sesuaikan teks notifikasi SnackBar jika item berhasil ditambahkan ke favorit.
      Get.snackbar(
        'Ditambahkan ke Favorit',
        '${character.name} berhasil ditambahkan ke daftar favorit!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.indigo,
        colorText: Colors.white,
        icon: const Icon(Icons.favorite, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void removeFavorite(CharacterModel character) {
    _favorites.removeWhere((item) => item.id == character.id);
    _saveFavorites();
    Get.snackbar(
      'Item Dihapus',
      '${character.name} telah dihapus dari daftar favorit.',
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
