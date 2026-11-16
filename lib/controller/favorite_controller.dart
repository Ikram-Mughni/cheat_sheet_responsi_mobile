import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/character_model.dart';

class FavoriteController extends GetxController {
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
    return 'rick_morty_favorites_$currentUser';
  }

  // Load favorit
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getFavKey();
    final String? rawData = prefs.getString(key);

    _favorites.clear();
    if (rawData != null && rawData.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(rawData);
        _favorites.assignAll(decoded.map((item) => CharacterModel.fromJson(item)).toList());
      } catch (e) {
        _favorites.clear();
      }
    }
  }

  // Simpan favorit
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getFavKey();
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
      Get.snackbar(
        'Dihapus dari Favorit',
        '${character.name} telah disingkirkan dari daftar favorit.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF161B26),
        borderColor: const Color(0xFFFF5252),
        borderWidth: 1.2,
        colorText: Colors.white,
        icon: const Icon(Icons.favorite_border, color: Color(0xFFFF5252)),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    } else {
      _favorites.add(character);
      _saveFavorites();
      Get.snackbar(
        'Ditambahkan ke Favorit',
        '${character.name} berhasil disimpan ke daftar favorit!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF161B26),
        borderColor: const Color(0xFF97CE4C),
        borderWidth: 1.2,
        colorText: Colors.white,
        icon: const Icon(Icons.favorite, color: Color(0xFFF0E14A)),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void removeFavorite(CharacterModel character) {
    _favorites.removeWhere((item) => item.id == character.id);
    _saveFavorites();
    Get.snackbar(
      'Karakter Dihapus',
      '${character.name} telah disingkirkan dari daftar favorit.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF161B26),
      borderColor: const Color(0xFFFF5252),
      borderWidth: 1.2,
      colorText: Colors.white,
      icon: const Icon(Icons.delete_sweep, color: Color(0xFFFF5252)),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  // Reset state favorit
  void clearState() {
    _favorites.clear();
  }
}
