import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../controller/root_controller.dart';
import 'episode_page.dart';
import 'favorite_page.dart';
import 'home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RootController rootController = Get.find<RootController>();
    final AuthController authController = Get.find<AuthController>();

    // TODO (RESPONSI): Sesuaikan daftar halaman yang dikelola oleh IndexedStack / BottomNavigationBar.
    final List<Widget> pages = const [
      HomePage(),
      FavoritePage(),
      EpisodePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                authController.username.isNotEmpty
                    ? 'Halo, ${authController.username}!'
                    : 'Halo, Pengguna!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              // TODO (RESPONSI): Ganti teks sub-judul di AppBar ini sesuai tema soal responsi.
              const Text(
                'Katalog Data & Informasi',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Get.defaultDialog(
                title: 'Konfirmasi Keluar',
                middleText: 'Apakah Anda yakin ingin keluar?',
                textConfirm: 'Ya, Keluar',
                textCancel: 'Batal',
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () {
                  Get.back();
                  authController.logout();
                },
              );
            },
          ),
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: rootController.currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: rootController.currentIndex,
          onTap: rootController.changeIndex,
          // TODO (RESPONSI): Sesuaikan label teks dan icon pada BottomNavigationBarItem sesuai kebutuhan soal.
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'Episode',
            ),
          ],
        ),
      ),
    );
  }
}
