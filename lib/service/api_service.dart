import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/character_model.dart';
import '../model/episode_model.dart';

class ApiService {
  // TODO (RESPONSI): Ganti link URL ini dengan Base URL endpoint API dari soal responsi.
  static const String _baseUrl = 'https://rickandmortyapi.com/api';

  // Fetch Data Utama (dengan filter & search)
  static Future<List<CharacterModel>> fetchCharacters({String? status, String? name}) async {
    try {
      final queryParams = <String, String>{};
      
      // TODO (RESPONSI): Sesuaikan parameter query filter dan search dengan dokumentasi API baru (misal: ?status= / ?category= / ?name= / ?search=).
      if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
        queryParams['status'] = status.toLowerCase();
      }
      if (name != null && name.trim().isNotEmpty) {
        queryParams['name'] = name.trim();
      }

      // TODO (RESPONSI): Ganti path endpoint ('/character') sesuai endpoint data utama pada soal responsi.
      final uri = Uri.parse('$_baseUrl/character').replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // TODO (RESPONSI): Sesuaikan key pembungkus list (misal: 'results', 'data', 'products', atau langsung decode jika root berupa List).
        final List<dynamic> results = data['results'] ?? [];
        return results.map((item) => CharacterModel.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Gagal memuat data (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  // Fetch Data Sekunder (misal: list episode / ulasan / kategori)
  static Future<List<EpisodeModel>> fetchEpisodes() async {
    try {
      // TODO (RESPONSI): Ganti path endpoint ('/episode') untuk pemanggilan data sekunder jika diminta di soal.
      final uri = Uri.parse('$_baseUrl/episode');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // TODO (RESPONSI): Sesuaikan key pembungkus data sekunder (misal: 'results', 'data', atau langsung List).
        final List<dynamic> results = data['results'] ?? [];
        return results.map((item) => EpisodeModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data sekunder (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}
