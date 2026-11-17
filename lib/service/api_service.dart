import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/wizard_model.dart'; // TERUBAH: Import WizardModel menggantikan CharacterModel
import '../model/spell_model.dart'; // TERUBAH: Import SpellModel menggantikan EpisodeModel

class ApiService {
  // TERUBAH: Base URL publik Harry Potter API (HP-API)
  static const String _baseUrl = 'https://hp-api.onrender.com/api';

  // TERUBAH: Mirror GitHub Raw resmi (100% bebas blokir CORS browser di Flutter Web & tidak pernah sleep/cold start)
  static const String _rawMirrorUrl = 'https://raw.githubusercontent.com/KostaSav/hp-api/master/data';

  // Fetch Data Utama Karakter Penyihir (dengan filter asrama & pencarian nama)
  static Future<List<WizardModel>> fetchWizards({String? house, String? name}) async {
    try {
      String targetUrl;
      // TERUBAH: Penyesuaian URL filter asrama
      if (house != null && house.isNotEmpty && house.toLowerCase() != 'all') {
        targetUrl = '$_baseUrl/characters/house/${house.toLowerCase()}';
      } else {
        targetUrl = '$_baseUrl/characters';
      }

      http.Response response;
      try {
        // Coba panggil server utama Render terlebih dahulu
        response = await http.get(Uri.parse(targetUrl)).timeout(const Duration(seconds: 4));
        if (response.statusCode != 200) {
          throw Exception('Status: ${response.statusCode}');
        }
      } catch (err) {
        // TERUBAH: Fallback otomatis ke GitHub Raw jika browser memblokir CORS di Flutter Web atau server Render sedang sleep
        response = await http.get(Uri.parse('$_rawMirrorUrl/characters.json'));
      }

      if (response.statusCode == 200) {
        // TERUBAH: HP-API me-return List<dynamic> di root
        final List<dynamic> results = jsonDecode(response.body);
        List<WizardModel> wizards = results.map((item) => WizardModel.fromJson(item)).toList();

        // TERUBAH: Filter asrama (house) diterapkan jika data diambil dari mirror lengkap
        if (house != null && house.isNotEmpty && house.toLowerCase() != 'all') {
          wizards = wizards.where((w) => w.house.toLowerCase() == house.toLowerCase()).toList();
        }

        // TERUBAH: Filter pencarian nama secara client-side
        if (name != null && name.trim().isNotEmpty) {
          final query = name.trim().toLowerCase();
          wizards = wizards.where((w) => w.name.toLowerCase().contains(query)).toList();
        }

        return wizards;
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
      http.Response response;
      try {
        // Coba panggil endpoint Render
        response = await http.get(Uri.parse('$_baseUrl/spells')).timeout(const Duration(seconds: 4));
        if (response.statusCode != 200) {
          throw Exception('Status: ${response.statusCode}');
        }
      } catch (err) {
        // TERUBAH: Fallback otomatis ke GitHub Raw jika Render diblokir CORS atau sedang sleep
        response = await http.get(Uri.parse('$_rawMirrorUrl/spells.json'));
      }

      if (response.statusCode == 200) {
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
