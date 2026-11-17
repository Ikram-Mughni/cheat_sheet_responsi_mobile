import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/spell_controller.dart'; // TERUBAH: Import SpellController menggantikan EpisodeController

// TERUBAH: Halaman SpellPage untuk menampilkan data sekunder Mantra Sihir (Spells)
class SpellPage extends StatelessWidget {
  const SpellPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TERUBAH: Mengambil instance SpellController
    final SpellController spellController = Get.find<SpellController>();

    return Scaffold(
      body: Obx(() {
        if (spellController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (spellController.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  // TERUBAH: Pesan error pemanggilan mantra
                  const Text(
                    'Gagal memuat daftar mantra',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    spellController.errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Coba Lagi'),
                    // TERUBAH: Refresh memanggil fetchSpells()
                    onPressed: () => spellController.fetchSpells(),
                  ),
                ],
              ),
            ),
          );
        }

        // TERUBAH: Pengecekan daftar spells kosong
        if (spellController.spells.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada mantra sihir yang tersedia.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          );
        }

        return RefreshIndicator(
          // TERUBAH: Pull-to-refresh data mantra
          onRefresh: () async => await spellController.fetchSpells(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: spellController.spells.length, // TERUBAH: Jumlah mantra
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final spell = spellController.spells[index]; // TERUBAH: Objek SpellModel

              return Card(
                elevation: 1,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  // TERUBAH: Leading icon tongkat sihir
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade50,
                    child: const Icon(Icons.auto_fix_high, color: Colors.deepPurple, size: 20),
                  ),
                  // TERUBAH: Menampilkan nama mantra
                  title: Text(
                    spell.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // TERUBAH: Menampilkan penjelasan / fungsi mantra
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      spell.description,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.3),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
