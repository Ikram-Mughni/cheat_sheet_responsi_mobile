import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_controller.dart';
import '../../routes/app_routes.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  static const Color _portalGreen = Color(0xFF97CE4C);
  static const Color _rickCyan = Color(0xFF00B5CC);
  static const Color _mortyYellow = Color(0xFFF0E14A);
  static const Color _darkCard = Color(0xFF161B26);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return _portalGreen;
      case 'dead':
        return const Color(0xFFFF5252);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteController favController = Get.find<FavoriteController>();

    return Scaffold(
      body: Obx(() {
        if (favController.favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _mortyYellow.withOpacity(0.1),
                      border: Border.all(color: _mortyYellow.withOpacity(0.3), width: 1.5),
                    ),
                    child: const Icon(Icons.favorite_border, size: 40, color: _mortyYellow),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Dimensi Favorit Masih Kosong',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Karakter yang Anda beri tanda love akan disimpan pada halaman ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF8B949E)),
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
            final statusColor = _getStatusColor(character.status);

            return Dismissible(
              key: Key('fav_${character.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFB00020),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Hapus dari Favorit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              onDismissed: (_) {
                favController.removeFavorite(character);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: _darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF262F40), width: 1.2),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: statusColor.withOpacity(0.5), width: 1.2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.network(
                          character.image,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 52,
                            height: 52,
                            color: const Color(0xFF202736),
                            child: const Icon(Icons.person, color: _rickCyan),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      character.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${character.status} - ${character.species}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF8B949E)),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: _rickCyan),
                    onTap: () {
                      Get.toNamed(AppRoutes.detail, arguments: character);
                    },
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
