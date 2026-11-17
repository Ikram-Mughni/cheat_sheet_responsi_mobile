import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/meal_model.dart';
import '../model/category_model.dart';

class ApiService {
  // TODO (RESPONSI): Ganti link URL ini dengan Base URL endpoint API dari soal responsi.
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Fetch Data Utama (dengan filter kategori & pencarian)
  static Future<List<MealModel>> fetchMeals({String? category, String? name}) async {
    try {
      Uri uri;
      final bool hasCategoryFilter =
          category != null && category.isNotEmpty && category.toLowerCase() != 'all';

      // TODO (RESPONSI): Sesuaikan endpoint filter vs search sesuai aturan API
      if (hasCategoryFilter) {
        uri = Uri.parse('$_baseUrl/filter.php?c=${Uri.encodeComponent(category)}');
      } else {
        final query = name?.trim() ?? '';
        uri = Uri.parse('$_baseUrl/search.php?s=${Uri.encodeComponent(query)}');
      }

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // TheMealDB me-return {"meals": null} jika data tidak ditemukan
        if (data['meals'] == null) {
          return [];
        }
        final List<dynamic> results = data['meals'];
        return results.map((item) {
          final meal = MealModel.fromJson(item);
          // Jika diambil dari filter category, sertakan info category yang dipilih
          if (hasCategoryFilter && (meal.category.isEmpty || meal.category == 'Umum')) {
            return MealModel(
              id: meal.id,
              name: meal.name,
              category: category,
              area: meal.area,
              instructions: meal.instructions,
              thumb: meal.thumb,
            );
          }
          return meal;
        }).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Gagal memuat resep makanan (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  // Fetch Detail Lengkap Resep (berdasarkan ID)
  static Future<MealModel?> fetchMealDetail(String id) async {
    try {
      final uri = Uri.parse('$_baseUrl/lookup.php?i=${Uri.encodeComponent(id)}');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['meals'] == null || (data['meals'] as List).isEmpty) {
          return null;
        }
        return MealModel.fromJson(data['meals'][0]);
      } else {
        throw Exception('Gagal memuat detail resep (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  // Fetch Data Sekunder (Daftar Kategori Resep)
  static Future<List<CategoryModel>> fetchCategories() async {
    try {
      final uri = Uri.parse('$_baseUrl/categories.php');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['categories'] == null) {
          return [];
        }
        final List<dynamic> results = data['categories'];
        return results.map((item) => CategoryModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat kategori masakan (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}
