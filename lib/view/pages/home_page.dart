import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/character_controller.dart';
import '../../routes/app_routes.dart';
import '../widgets/character_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final CharacterController _charController = Get.find<CharacterController>();

  static const Color _portalGreen = Color(0xFF97CE4C);
  static const Color _rickCyan = Color(0xFF00B5CC);
  static const Color _darkSurface = Color(0xFF131720);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusList = ['All', 'Alive', 'Dead', 'Unknown'];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          color: _darkSurface,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cari nama karakter...',
                    hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: _rickCyan, size: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF8B949E), size: 18),
                      tooltip: 'Hapus teks',
                      onPressed: () {
                        _searchController.clear();
                        _charController.setSearchQuery('');
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    filled: true,
                    fillColor: const Color(0xFF1C2230),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Color(0xFF2E384D)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Color(0xFF2E384D)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: _portalGreen, width: 1.8),
                    ),
                  ),
                  onSubmitted: (value) => _charController.setSearchQuery(value),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _portalGreen,
                    foregroundColor: const Color(0xFF0D1117),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text(
                    'Cari',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _charController.setSearchQuery(_searchController.text);
                  },
                ),
              ),
            ],
          ),
        ),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          color: _darkSurface,
          child: Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: statusList.map((status) {
                  final isSelected = _charController.selectedStatus == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(status),
                      selected: isSelected,
                      showCheckmark: false,
                      backgroundColor: const Color(0xFF1C2230),
                      selectedColor: _portalGreen,
                      side: BorderSide(
                        color: isSelected ? _portalGreen : const Color(0xFF2E384D),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF0D1117) : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (_) => _charController.setStatusFilter(status),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        Container(
          height: 1,
          color: const Color(0xFF262F40),
        ),

        Expanded(
          child: Obx(() {
            if (_charController.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: _portalGreen),
                    SizedBox(height: 14),
                    Text(
                      'Menghubungi Portal Multiverse...',
                      style: TextStyle(color: _rickCyan, fontSize: 13),
                    ),
                  ],
                ),
              );
            }

            if (_charController.errorMessage.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 54, color: Color(0xFFFF5252)),
                      const SizedBox(height: 12),
                      const Text(
                        'Koneksi Multiverse Terputus!',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _charController.errorMessage,
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
                        onPressed: () => _charController.fetchCharacters(),
                        label: const Text('Coba Lagi', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (_charController.characters.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 60, color: Colors.grey.shade600),
                    const SizedBox(height: 12),
                    const Text(
                      'Karakter tidak ditemukan di dimensi ini.',
                      style: TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Coba gunakan kata kunci nama atau filter lain.',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF0D1117),
              backgroundColor: _portalGreen,
              onRefresh: () async => await _charController.fetchCharacters(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _charController.characters.length,
                itemBuilder: (context, index) {
                  final character = _charController.characters[index];
                  return CharacterCard(
                    character: character,
                    onTap: () {
                      Get.toNamed(AppRoutes.detail, arguments: character);
                    },
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
