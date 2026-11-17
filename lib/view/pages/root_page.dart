import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../controller/root_controller.dart';
import '../../controller/wizard_controller.dart'; // TERUBAH: Import WizardController
import 'favorite_page.dart';
import 'home_page.dart';
import 'spell_page.dart'; // TERUBAH: Import SpellPage menggantikan EpisodePage

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RootController rootController = Get.find<RootController>();
    final AuthController authController = Get.find<AuthController>();

    // TERUBAH: Mengganti halaman ketiga menjadi SpellPage
    final List<Widget> pages = const [
      HomePage(),
      FavoritePage(),
      SpellPage(),
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
                    : 'Halo, Penyihir!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              // TERUBAH: Subtitle AppBar disesuaikan dengan tema Hogwarts
              const Text(
                'Katalog Dunia Sihir Hogwarts',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // TERUBAH: Tombol Sort A-Z di AppBar saat aktif di tab Penyihir (Bonus 2)
          Obx(() {
            if (rootController.currentIndex == 0) {
              final wizardController = Get.find<WizardController>();
              return Obx(() => IconButton(
                    icon: Icon(
                      wizardController.isAscending ? Icons.sort_by_alpha : Icons.sort,
                      color: wizardController.isAscending ? Colors.amberAccent : Colors.white,
                    ),
                    tooltip: wizardController.isAscending ? 'Kembalikan Urutan' : 'Urutkan A-Z',
                    onPressed: () => wizardController.toggleSort(),
                  ));
            }
            return const SizedBox.shrink();
          }),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Get.defaultDialog(
                title: 'Konfirmasi Keluar',
                middleText: 'Apakah Anda yakin ingin keluar dari Hogwarts Explorer?',
                textConfirm: 'Ya, Keluar',
                textCancel: 'Batal',
                confirmTextColor: Colors.white,
                buttonColor: Colors.deepPurple,
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
          // TERUBAH: Item BottomNavigationBar disesuaikan menjadi Penyihir, Favorit, dan Mantra
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_outlined),
              activeIcon: Icon(Icons.auto_awesome),
              label: 'Penyihir',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Mantra',
            ),
          ],
        ),
      ),
    );
  }
}
