import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_controller.dart';
import '../../model/character_model.dart';

class CharacterCard extends StatelessWidget {
  // TODO (RESPONSI): Ganti tipe Model 'CharacterModel' dengan Model baru (misal: MovieModel movie).
  final CharacterModel character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final FavoriteController favController = Get.find<FavoriteController>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Gambar Thumbnail Item
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  // TODO (RESPONSI): Sesuaikan pemanggilan data gambar ini dengan properti model baru (misal: item.poster / item.image).
                  character.image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Informasi Item
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO (RESPONSI): Sesuaikan pemanggilan data judul/nama utama ini dengan atribut model baru (misal: item.name / item.title).
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // TODO (RESPONSI): Sesuaikan pemanggilan data sub-informasi ini dengan atribut model baru (misal: item.category / item.year).
                    Text(
                      '${character.status} • ${character.species}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // TODO (RESPONSI): Sesuaikan atau ganti baris info ketiga ini (misal: rating, harga, atau lokasi).
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            character.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tombol Favorit Reaktif
              Obx(() {
                // TODO (RESPONSI): Sesuaikan ID unik objek model (misal: character.id / movie.id).
                final isFav = favController.isFavorite(character.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                  tooltip: isFav ? 'Hapus dari favorit' : 'Tambah favorit',
                  onPressed: () => favController.toggleFavorite(character),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
