import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/character_model.dart';
import '../model/episode_model.dart';

class ApiService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';

  static Future<List<CharacterModel>> fetchCharacters({String? status, String? name}) async {
    try {
      final queryParams = <String, String>{};
      if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
        queryParams['status'] = status.toLowerCase();
      }
      if (name != null && name.trim().isNotEmpty) {
        queryParams['name'] = name.trim();
      }

      final uri = Uri.parse('$_baseUrl/character').replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((item) => CharacterModel.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Gagal memuat karakter (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  static Future<List<EpisodeModel>> fetchEpisodes() async {
    try {
      final uri = Uri.parse('$_baseUrl/episode');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((item) => EpisodeModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat episode (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}

