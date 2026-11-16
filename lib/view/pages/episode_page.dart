import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/episode_controller.dart';

// TODO (RESPONSI): Halaman ini berfungsi sebagai template list data sekunder (misal: Episodes, Reviews, Authors, Chapters).
class EpisodePage extends StatelessWidget {
  const EpisodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final EpisodeController episodeController = Get.find<EpisodeController>();

    return Scaffold(
      body: Obx(() {
        if (episodeController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (episodeController.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  // TODO (RESPONSI): Ganti teks pesan error sesuai data yang dipanggil.
                  const Text(
                    'Gagal memuat data sekunder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    episodeController.errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Coba Lagi'),
                    onPressed: () => episodeController.fetchEpisodes(),
                  ),
                ],
              ),
            ),
          );
        }

        if (episodeController.episodes.isEmpty) {
          return Center(
            child: Text(
              // TODO (RESPONSI): Ganti teks status kosong jika data sekunder tidak ada.
              'Tidak ada data yang tersedia.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => await episodeController.fetchEpisodes(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: episodeController.episodes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final episode = episodeController.episodes[index];

              return Card(
                elevation: 1,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade50,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // TODO (RESPONSI): Sesuaikan judul item data sekunder dengan properti model baru.
                  title: Text(
                    episode.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  // TODO (RESPONSI): Sesuaikan subtitle data sekunder dengan atribut model baru.
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 13, color: Colors.grey.shade600),
                        const SizedBox(width: 5),
                        Text(
                          episode.airDate,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  // TODO (RESPONSI): Sesuaikan badge trailing informasi tambahan (misal: kode, rating, atau tag).
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      episode.episodeCode,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade700,
                      ),
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
