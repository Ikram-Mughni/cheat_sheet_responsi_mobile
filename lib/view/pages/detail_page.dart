import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_controller.dart';
import '../../model/wizard_model.dart'; // TERUBAH: Import WizardModel menggantikan CharacterModel

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple), // TERUBAH: Warna aksen ungu magis
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
    // TERUBAH: Mengambil argument dan casting ke WizardModel
    final WizardModel wizard = Get.arguments as WizardModel;
    final FavoriteController favController = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        // TERUBAH: Judul AppBar menampilkan nama penyihir
        title: Text(wizard.name),
        actions: [
          Obx(() {
            // TERUBAH: Memeriksa status favorit dengan wizard.id String
            final isFav = favController.isFavorite(wizard.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.redAccent : Colors.white,
              ),
              tooltip: isFav ? 'Hapus dari favorit' : 'Tambah ke favorit',
              // TERUBAH: Toggle favorit menggunakan objek wizard
              onPressed: () => favController.toggleFavorite(wizard),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Utama (Hero Banner Foto Penyihir)
            Container(
              width: double.infinity,
              height: 280,
              color: Colors.grey.shade100,
              // TERUBAH: Fallback gambar jika wizard.image kosong dari API
              child: wizard.image.isNotEmpty
                  ? Image.network(
                      wizard.image, // TERUBAH: URL foto karakter penyihir
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                      ),
                    )
                  : Container(
                      color: Colors.deepPurple.shade100,
                      child: const Center(
                        child: Icon(Icons.auto_awesome, size: 80, color: Colors.deepPurple),
                      ),
                    ),
            ),

            // Konten Detail
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul & Badge Asrama + Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        // TERUBAH: Menampilkan nama penyihir
                        child: Text(
                          wizard.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // TERUBAH: Badge status hidup (Alive/Deceased)
                      Chip(
                        label: Text(
                          wizard.alive ? 'Alive' : 'Deceased',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: wizard.alive ? Colors.green.shade800 : Colors.red.shade800,
                          ),
                        ),
                        backgroundColor: wizard.alive ? Colors.green.shade50 : Colors.red.shade50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Card Informasi Rinci Penyihir
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TERUBAH: Judul kartu informasi Hogwarts
                          const Text(
                            'Informasi Profil Penyihir',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const Divider(height: 24),
                          // TERUBAH: Baris-baris informasi detail karakter Hogwarts
                          _buildDetailRow(Icons.shield_outlined, 'Asrama (House)', wizard.house),
                          _buildDetailRow(Icons.person_outline, 'Spesies', wizard.species),
                          _buildDetailRow(Icons.theater_comedy_outlined, 'Aktor Pemeran', wizard.actor),
                          _buildDetailRow(Icons.auto_fix_high, 'Patronus', wizard.patronus),
                          _buildDetailRow(Icons.cake_outlined, 'Tanggal Lahir', wizard.dateOfBirth),
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
        // TERUBAH: Cek status favorit reaktif dengan wizard.id
        final isFav = favController.isFavorite(wizard.id);
        return FloatingActionButton.extended(
          // TERUBAH: Toggle favorit dengan objek wizard
          onPressed: () => favController.toggleFavorite(wizard),
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          // TERUBAH: Label tombol aksi favorit
          label: Text(isFav ? 'Hapus Favorit' : 'Simpan Penyihir'),
          backgroundColor: isFav ? Colors.red.shade600 : Colors.deepPurple,
          foregroundColor: Colors.white,
        );
      }),
    );
  }
}
