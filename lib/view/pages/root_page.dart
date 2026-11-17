import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../controller/meal_controller.dart';
import '../../controller/root_controller.dart';
import 'category_page.dart';
import 'favorite_page.dart';
import 'home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RootController rootController = Get.find<RootController>();
    final AuthController authController = Get.find<AuthController>();

    final List<Widget> pages = const [
      HomePage(),
      FavoritePage(),
      CategoryPage(),
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
                    : 'Halo, Pecinta Kuliner!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Katalog Resep & Kuliner Dunia',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Bonus 2: Tombol Sort A-Z di AppBar saat berada di tab Resep
          Obx(() {
            if (rootController.currentIndex == 0) {
              final mealController = Get.find<MealController>();
              return Obx(() => IconButton(
                    icon: Icon(
                      mealController.isAscending ? Icons.sort_by_alpha : Icons.sort,
                      color: mealController.isAscending ? Colors.amberAccent : Colors.white,
                    ),
                    tooltip: mealController.isAscending ? 'Kembalikan Urutan' : 'Urutkan A-Z',
                    onPressed: () => mealController.toggleSort(),
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
                middleText: 'Apakah Anda yakin ingin keluar dari akun?',
                textConfirm: 'Ya, Keluar',
                textCancel: 'Batal',
                confirmTextColor: Colors.white,
                buttonColor: Colors.deepOrange,
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Resep',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Kategori',
            ),
          ],
        ),
      ),
    );
  }
}
