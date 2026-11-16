import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_controller.dart';
import '../../routes/app_routes.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favController = Get.find<FavoriteController>();

    return Scaffold(
      body: Obx(() {
        if (favController.favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  // TODO (RESPONSI): Ganti teks judul status kosong ini sesuai tema aplikasi.
                  const Text(
                    'Belum ada data favorit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Item yang Anda sukai akan tersimpan pada daftar ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: favController.favorites.length,
          itemBuilder: (context, index) {
            final character = favController.favorites[index];

            return Dismissible(
              // TODO (RESPONSI): Sesuaikan ID unik model (misal: item.id / item.idMeal).
              key: Key('fav_${character.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Hapus',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              onDismissed: (_) {
                favController.removeFavorite(character);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      // TODO (RESPONSI): Sesuaikan pemanggilan data gambar thumbnail ini dengan model baru.
                      character.image,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 52,
                        height: 52,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                  ),
                  // TODO (RESPONSI): Sesuaikan nama/judul objek model favorit.
                  title: Text(
                    character.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // TODO (RESPONSI): Sesuaikan sub-informasi objek model favorit.
                  subtitle: Text('${character.status} • ${character.species}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () {
                    // TODO (RESPONSI): Sesuaikan data arguments yang dikirim ke halaman detail.
                    Get.toNamed(AppRoutes.detail, arguments: character);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
