import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_controller.dart';
import '../../model/wizard_model.dart'; // TERUBAH: Menggunakan WizardModel menggantikan CharacterModel

class WizardCard extends StatelessWidget {
  // TERUBAH: Mengganti CharacterModel menjadi WizardModel wizard
  final WizardModel wizard;
  final VoidCallback onTap;

  const WizardCard({
    super.key,
    required this.wizard,
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
              // Gambar Thumbnail Karakter Penyihir
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // TERUBAH: Menambahkan fallback aman jika wizard.image kosong dari API
                child: wizard.image.isNotEmpty
                    ? Image.network(
                        wizard.image, // TERUBAH: Menggunakan atribut wizard.image
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
                          color: Colors.deepPurple.shade50,
                          child: const Icon(Icons.auto_awesome, color: Colors.deepPurple),
                        ),
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        color: Colors.deepPurple.shade50,
                        child: const Icon(Icons.person, color: Colors.deepPurple),
                      ),
              ),
              const SizedBox(width: 14),

              // Informasi Karakter Penyihir
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TERUBAH: Menampilkan nama penyihir (wizard.name)
                    Text(
                      wizard.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // TERUBAH: Menampilkan asrama (house) dan spesies (species)
                    Text(
                      '${wizard.house} • ${wizard.species}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // TERUBAH: Menampilkan patronus dan status alive
                    Row(
                      children: [
                        Icon(
                          wizard.alive ? Icons.favorite : Icons.heart_broken,
                          size: 14,
                          color: wizard.alive ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Patronus: ${wizard.patronus}',
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
                // TERUBAH: Cek favorit dengan String UUID wizard.id
                final isFav = favController.isFavorite(wizard.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                  tooltip: isFav ? 'Hapus dari favorit' : 'Tambah favorit',
                  // TERUBAH: Memanggil toggleFavorite dengan objek wizard
                  onPressed: () => favController.toggleFavorite(wizard),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
