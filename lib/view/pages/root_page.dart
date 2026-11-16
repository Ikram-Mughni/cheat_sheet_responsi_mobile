import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../controller/root_controller.dart';
import 'episode_page.dart';
import 'favorite_page.dart';
import 'home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  static const Color _portalGreen = Color(0xFF97CE4C);
  static const Color _rickCyan = Color(0xFF00B5CC);
  static const Color _appBarDark = Color(0xFF131720);

  @override
  Widget build(BuildContext context) {
    final RootController rootController = Get.find<RootController>();
    final AuthController authController = Get.find<AuthController>();

    final List<Widget> pages = const [
      HomePage(),
      FavoritePage(),
      EpisodePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarDark,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => Text(
                authController.username.isNotEmpty
                    ? 'Halo, ${authController.username}!'
                    : 'Halo, Explorer!',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 2),
            const Row(
              children: [
                Icon(Icons.public, size: 12, color: _portalGreen),
                SizedBox(width: 4),
                Text(
                  'Explore Rick & Morty Universe',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _rickCyan,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            tooltip: 'Logout',
            onPressed: () {
              Get.defaultDialog(
                title: 'Konfirmasi Keluar',
                titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                middleText: 'Apakah Anda yakin ingin keluar?',
                middleTextStyle: const TextStyle(color: Colors.white70),
                backgroundColor: const Color(0xFF161B26),
                radius: 14,
                textConfirm: 'Keluar',
                textCancel: 'Batal',
                confirmTextColor: const Color(0xFF0D1117),
                cancelTextColor: _rickCyan,
                buttonColor: _portalGreen,
                onConfirm: () {
                  Get.back();
                  authController.logout();
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF262F40),
            height: 1,
          ),
        ),
      ),
      body: Obx(() => IndexedStack(
            index: rootController.currentIndex,
            children: pages,
          )),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF262F40), width: 1),
          ),
        ),
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: rootController.currentIndex,
            backgroundColor: _appBarDark,
            selectedItemColor: _portalGreen,
            unselectedItemColor: const Color(0xFF6B7280),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            onTap: rootController.changeIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined),
                activeIcon: Icon(Icons.people_alt, color: _portalGreen),
                label: 'Characters',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite, color: _portalGreen),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_library_outlined),
                activeIcon: Icon(Icons.video_library, color: _portalGreen),
                label: 'Episodes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
