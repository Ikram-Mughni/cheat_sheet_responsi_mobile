import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_controller.dart';
import '../../model/character_model.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

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

  Widget _buildSpecCard(IconData icon, String label, String value, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF262F40), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: Color(0xFF8B949E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CharacterModel character = Get.arguments as CharacterModel;
    final FavoriteController favController = Get.find<FavoriteController>();
    final statusColor = _getStatusColor(character.status);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          character.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          Obx(() {
            final isFav = favController.isFavorite(character.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? _mortyYellow : Colors.white,
                size: 26,
              ),
              tooltip: isFav ? 'Hapus dari favorit' : 'Tambah ke favorit',
              onPressed: () => favController.toggleFavorite(character),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF131720),
                    Color(0xFF0D1117),
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: statusColor.withOpacity(0.8), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.4),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      character.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF1C2230),
                        child: const Icon(Icons.person, color: _rickCyan, size: 80),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.6), width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withOpacity(0.8),
                                blurRadius: 6,      
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          character.status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSpecCard(Icons.fingerprint, 'Spesies', character.species, _rickCyan),
                  const SizedBox(height: 10),
                  _buildSpecCard(Icons.transgender, 'Gender', character.gender, _portalGreen),
                  const SizedBox(height: 10),
                  _buildSpecCard(Icons.public, 'Asal Dimensi (Origin)', character.origin, _mortyYellow),
                  const SizedBox(height: 10),
                  _buildSpecCard(Icons.near_me, 'Lokasi Terakhir', character.location, const Color(0xFFFF7A00)),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        final isFav = favController.isFavorite(character.id);
        return FloatingActionButton.extended(
          backgroundColor: isFav ? _mortyYellow : _portalGreen,
          foregroundColor: const Color(0xFF0D1117),
          elevation: 6,
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          label: Text(
            isFav ? 'HAPUS FAVORIT' : 'TAMBAH FAVORIT',
            style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.8),
          ),
          onPressed: () => favController.toggleFavorite(character),
        );
      }),
    );
  }
}
