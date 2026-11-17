import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/wizard_model.dart'; // TERUBAH: Import WizardModel menggantikan CharacterModel
import '../model/spell_model.dart'; // TERUBAH: Import SpellModel menggantikan EpisodeModel

class ApiService {
  // TERUBAH: Mengganti Base URL menjadi endpoint publik Harry Potter API (HP-API)
  static const String _baseUrl = 'https://hp-api.onrender.com/api';

  // Fetch Data Utama Karakter Penyihir (dengan filter asrama & pencarian nama)
  static Future<List<WizardModel>> fetchWizards({String? house, String? name}) async {
    try {
      Uri uri;
      // TERUBAH: Mengecek filter asrama Hogwarts (house), jika 'All' atau kosong ambil semua karakter
      if (house != null && house.isNotEmpty && house.toLowerCase() != 'all') {
        // TERUBAH: Menggunakan endpoint /characters/house/{house} untuk filter asrama
        uri = Uri.parse('$_baseUrl/characters/house/${house.toLowerCase()}');
      } else {
        // TERUBAH: Menggunakan endpoint /characters untuk memuat seluruh karakter
        uri = Uri.parse('$_baseUrl/characters');
      }

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // TERUBAH: HP-API me-return langsung List<dynamic> di root (bukan Map dengan key 'results')
        final List<dynamic> results = jsonDecode(response.body);
        List<WizardModel> wizards = results.map((item) => WizardModel.fromJson(item)).toList();

        // TERUBAH: Menyaring pencarian nama secara client-side jika kata kunci diisi
        if (name != null && name.trim().isNotEmpty) {
          final query = name.trim().toLowerCase();
          wizards = wizards.where((w) => w.name.toLowerCase().contains(query)).toList();
        }

        return wizards;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Gagal memuat data penyihir (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  // Fetch Data Sekunder: Daftar Mantra Sihir (Spells)
  static Future<List<SpellModel>> fetchSpells() async {
    try {
      // TERUBAH: Mengganti path endpoint data sekunder menjadi '/spells'
      final uri = Uri.parse('$_baseUrl/spells');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // TERUBAH: HP-API me-return List<dynamic> langsung untuk spells
        final List<dynamic> results = jsonDecode(response.body);
        return results.map((item) => SpellModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat daftar mantra (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}
