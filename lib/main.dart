import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();
  await Hive.openBox('usersBox');

  // Cek session login
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(App(initialRoute: isLoggedIn ? AppRoutes.root : AppRoutes.login));
}

class App extends StatelessWidget {
  final String initialRoute;

  const App({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // TERUBAH: Mengganti judul aplikasi menjadi 'Hogwarts Wizarding Explorer'
      title: 'Hogwarts Wizarding Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // TERUBAH: Bonus 1 - Mengganti tema warna utama menjadi Colors.deepPurple (warna magis Hogwarts)
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F8FD),
        appBarTheme: const AppBarTheme(
          // TERUBAH: Warna AppBar deepPurple
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 1,
          centerTitle: false,
        ),
        cardColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            // TERUBAH: Border input aktif deepPurple
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          // TERUBAH: Warna item aktif BottomNavigationBar deepPurple
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
