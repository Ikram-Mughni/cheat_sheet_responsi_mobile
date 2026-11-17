import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/wizard_model.dart'; // TERUBAH: Import WizardModel menggantikan CharacterModel

class FavoriteController extends GetxController {
  // TERUBAH: Mengganti tipe data list menjadi RxList<WizardModel>
  final RxList<WizardModel> _favorites = <WizardModel>[].obs;
  List<WizardModel> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Key SharedPreferences per user
  Future<String> _getFavKey() async {
    final prefs = await SharedPreferences.getInstance();
    final String currentUser = prefs.getString('currentUser') ?? 'guest';
    // TERUBAH: Mengubah prefix key favorit menjadi 'hogwarts_favorites_' sesuai ketentuan soal
    return 'hogwarts_favorites_$currentUser';
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
        // TERUBAH: Menggunakan WizardModel.fromJson untuk deserialize data karakter favorit
        _favorites.assignAll(decoded.map((item) => WizardModel.fromJson(item)).toList());
      } catch (e) {
        _favorites.clear();
      }
    }
  }

  // Simpan data favorit ke SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getFavKey();
    // TERUBAH: Menggunakan toJson() dari WizardModel
    final String encoded = jsonEncode(_favorites.map((e) => e.toJson()).toList());
    await prefs.setString(key, encoded);
  }

  // TERUBAH: Mengubah parameter tipe id dari int menjadi String (UUID HP-API)
  bool isFavorite(String id) {
    return _favorites.any((wizard) => wizard.id == id);
  }

  // TERUBAH: Mengubah parameter method toggleFavorite menjadi WizardModel wizard
  void toggleFavorite(WizardModel wizard) {
    if (isFavorite(wizard.id)) {
      _favorites.removeWhere((item) => item.id == wizard.id);
      _saveFavorites();
      // TERUBAH: Notifikasi SnackBar saat karakter dihapus dari favorit
      Get.snackbar(
        'Dihapus dari Favorit',
        '${wizard.name} telah dihapus dari daftar favorit Hogwarts.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade800,
        colorText: Colors.white,
        icon: const Icon(Icons.favorite_border, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    } else {
      _favorites.add(wizard);
      _saveFavorites();
      // TERUBAH: Notifikasi SnackBar saat karakter ditambahkan ke favorit bertema ungu magis
      Get.snackbar(
        'Ditambahkan ke Favorit',
        '${wizard.name} berhasil ditambahkan ke daftar penyihir favorit!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.deepPurple,
        colorText: Colors.white,
        icon: const Icon(Icons.favorite, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // TERUBAH: Mengubah parameter method removeFavorite menjadi WizardModel wizard
  void removeFavorite(WizardModel wizard) {
    _favorites.removeWhere((item) => item.id == wizard.id);
    _saveFavorites();
    Get.snackbar(
      'Karakter Dihapus',
      '${wizard.name} telah dihapus dari daftar favorit.',
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
