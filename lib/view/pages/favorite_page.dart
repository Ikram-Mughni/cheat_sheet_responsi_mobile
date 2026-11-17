import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_controller.dart';
import '../../model/wizard_model.dart'; // TERUBAH: Import WizardModel menggantikan CharacterModel
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
                  // TERUBAH: Pesan status favorit kosong khusus Hogwarts
                  const Text(
                    'Belum ada penyihir favorit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Karakter penyihir yang Anda sukai akan tersimpan pada daftar ini.',
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
            // TERUBAH: Mengambil data WizardModel favorit
            final wizard = favController.favorites[index];

            return Dismissible(
              // TERUBAH: Key unik menggunakan wizard.id String UUID
              key: Key('fav_${wizard.id}'),
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
                // TERUBAH: Memanggil removeFavorite dengan objek wizard
                favController.removeFavorite(wizard);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    // TERUBAH: Fallback gambar jika wizard.image kosong
                    child: wizard.image.isNotEmpty
                        ? Image.network(
                            wizard.image, // TERUBAH: Foto thumbnail penyihir favorit
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 52,
                              height: 52,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.person, color: Colors.grey),
                            ),
                          )
                        : Container(
                            width: 52,
                            height: 52,
                            color: Colors.deepPurple.shade50,
                            child: const Icon(Icons.auto_awesome, color: Colors.deepPurple),
                          ),
                  ),
                  // TERUBAH: Nama karakter penyihir
                  title: Text(
                    wizard.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // TERUBAH: Subtitle asrama dan spesies karakter
                  subtitle: Text('${wizard.house} • ${wizard.species}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () {
                    // TERUBAH: Navigasi ke detail dengan membawa objek wizard
                    Get.toNamed(AppRoutes.detail, arguments: wizard);
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
