import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_controller.dart';
import '../../model/character_model.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
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
    // TODO (RESPONSI): Ganti casting 'as CharacterModel' sesuai dengan Model data yang dikirim via Get.arguments.
    final CharacterModel character = Get.arguments as CharacterModel;
    final FavoriteController favController = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        // TODO (RESPONSI): Sesuaikan judul AppBar dengan nama/title objek model.
        title: Text(character.name),
        actions: [
          Obx(() {
            // TODO (RESPONSI): Sesuaikan ID unik model untuk cek status favorit.
            final isFav = favController.isFavorite(character.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.white,
              ),
              tooltip: isFav ? 'Hapus dari favorit' : 'Tambah ke favorit',
              onPressed: () => favController.toggleFavorite(character),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Utama (Hero Banner)
            Container(
              width: double.infinity,
              height: 280,
              color: Colors.grey.shade100,
              child: Image.network(
                // TODO (RESPONSI): Sesuaikan pemanggilan data gambar utama ini dengan properti model yang baru (misal: item.image / item.poster).
                character.image,
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
                  // Judul & Badge Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // TODO (RESPONSI): Sesuaikan pemanggilan data judul/nama utama ini dengan properti model yang baru.
                        child: Text(
                          character.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // TODO (RESPONSI): Sesuaikan badge kategori/status dengan field model baru.
                      Chip(
                        label: Text(
                          character.status,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: character.status.toLowerCase() == 'alive'
                            ? Colors.green.shade100
                            : (character.status.toLowerCase() == 'dead'
                                ? Colors.red.shade100
                                : Colors.grey.shade200),
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
                          // TODO (RESPONSI): Ganti teks judul section kartu info ini sesuai tema aplikasi.
                          const Text(
                            'Informasi Lengkap',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const Divider(height: 24),
                          // TODO (RESPONSI): Sesuaikan baris-baris informasi detail ini dengan atribut model baru.
                          _buildDetailRow(Icons.category_outlined, 'Spesies', character.species),
                          _buildDetailRow(Icons.person_outline, 'Gender', character.gender),
                          _buildDetailRow(Icons.public_outlined, 'Asal (Origin)', character.origin),
                          _buildDetailRow(Icons.location_on_outlined, 'Lokasi', character.location),
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
        final isFav = favController.isFavorite(character.id);
        return FloatingActionButton.extended(
          onPressed: () => favController.toggleFavorite(character),
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          // TODO (RESPONSI): Ganti label teks tombol aksi favorit jika diperlukan.
          label: Text(isFav ? 'Hapus Favorit' : 'Tambah Favorit'),
          backgroundColor: isFav ? Colors.red : Colors.indigo,
          foregroundColor: Colors.white,
        );
      }),
    );
  }
}
