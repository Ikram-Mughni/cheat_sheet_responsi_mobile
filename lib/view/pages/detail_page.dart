import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_controller.dart';
import '../../model/meal_model.dart';
import '../../service/api_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late MealModel _meal;
  bool _isLoadingDetail = false;

  @override
  void initState() {
    super.initState();
    _meal = Get.arguments as MealModel;
    _checkAndFetchFullDetail();
  }

  Future<void> _checkAndFetchFullDetail() async {
    // Jika data berasal dari filter kategori (instruksi masih default), ambil detail lengkap
    if (_meal.instructions == 'Tidak ada instruksi khusus.' || _meal.area == 'Internasional') {
      setState(() => _isLoadingDetail = true);
      try {
        final fullMeal = await ApiService.fetchMealDetail(_meal.id);
        if (fullMeal != null && mounted) {
          setState(() {
            _meal = fullMeal;
          });
        }
      } catch (_) {}
      if (mounted) {
        setState(() => _isLoadingDetail = false);
      }
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.deepOrange),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteController favController = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_meal.name),
        actions: [
          Obx(() {
            final isFav = favController.isFavorite(_meal.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.redAccent : Colors.white,
              ),
              tooltip: isFav ? 'Hapus dari favorit' : 'Tambah ke favorit',
              onPressed: () => favController.toggleFavorite(_meal),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Foto Resep
            Container(
              width: double.infinity,
              height: 280,
              color: Colors.grey.shade100,
              child: Image.network(
                _meal.thumb,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                ),
              ),
            ),

            // Konten Detail
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Resep & Badge Kategori
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _meal.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                          _meal.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        backgroundColor: Colors.deepOrange.shade50,
                        side: BorderSide(color: Colors.deepOrange.shade200),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Card Informasi Rinci
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Resep',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(Icons.restaurant_menu, 'Kategori', _meal.category),
                          _buildDetailRow(Icons.public, 'Asal Masakan', _meal.area),
                          _buildDetailRow(Icons.tag, 'ID Resep', _meal.id),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card Instruksi Memasak
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Instruksi Memasak',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              if (_isLoadingDetail)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                            ],
                          ),
                          const Divider(height: 24),
                          Text(
                            _meal.instructions,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        final isFav = favController.isFavorite(_meal.id);
        return FloatingActionButton.extended(
          onPressed: () => favController.toggleFavorite(_meal),
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          label: Text(isFav ? 'Hapus Favorit' : 'Simpan Resep'),
          backgroundColor: isFav ? Colors.red.shade600 : Colors.deepOrange,
          foregroundColor: Colors.white,
        );
      }),
    );
  }
}
