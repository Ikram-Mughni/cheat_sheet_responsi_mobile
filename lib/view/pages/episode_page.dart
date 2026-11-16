import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/episode_controller.dart';

class EpisodePage extends StatelessWidget {
  const EpisodePage({super.key});

  static const Color _portalGreen = Color(0xFF97CE4C);
  static const Color _rickCyan = Color(0xFF00B5CC);
  static const Color _darkCard = Color(0xFF161B26);

  @override
  Widget build(BuildContext context) {
    final EpisodeController episodeController = Get.find<EpisodeController>();

    return Scaffold(
      body: Obx(() {
        if (episodeController.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: _portalGreen),
                SizedBox(height: 14),
                Text(
                  'Mengambil transmisi siaran episode...',
                  style: TextStyle(color: _rickCyan, fontSize: 13),
                ),
              ],
            ),
          );
        }

        if (episodeController.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.satellite_alt_outlined, size: 54, color: Color(0xFFFF5252)),
                  const SizedBox(height: 12),
                  const Text(
                    'Transmisi Episode Gagal!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    episodeController.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF8B949E)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _rickCyan,
                      foregroundColor: const Color(0xFF0D1117),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: () => episodeController.fetchEpisodes(),
                    label: const Text('Coba Lagi', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        }

        if (episodeController.episodes.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada transmisi episode yang ditemukan.',
              style: TextStyle(color: Color(0xFF8B949E)),
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFF0D1117),
          backgroundColor: _portalGreen,
          onRefresh: () async => await episodeController.fetchEpisodes(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            itemCount: episodeController.episodes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final episode = episodeController.episodes[index];

              return Container(
                decoration: BoxDecoration(
                  color: _darkCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF262F40), width: 1.2),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _portalGreen.withOpacity(0.12),
                      border: Border.all(color: _portalGreen.withOpacity(0.4), width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(
                          color: _portalGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    episode.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 13, color: _rickCyan),
                        const SizedBox(width: 5),
                        Text(
                          episode.airDate,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF8B949E)),
                        ),
                      ],
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _rickCyan.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _rickCyan.withOpacity(0.4), width: 1),
                    ),
                    child: Text(
                      episode.episodeCode,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: _rickCyan,
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
