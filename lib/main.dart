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

  runApp(RickAndMortyApp(initialRoute: isLoggedIn ? AppRoutes.root : AppRoutes.login));
}

class RickAndMortyApp extends StatelessWidget {
  final String initialRoute;

  const RickAndMortyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    const portalGreen = Color(0xFF97CE4C);
    const rickCyan = Color(0xFF00B5CC);
    const darkBackground = Color(0xFF0D1117);
    const darkSurface = Color(0xFF161B26);

    return GetMaterialApp(
      title: 'Rick & Morty Character Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: portalGreen,
          secondary: rickCyan,
          surface: darkSurface,
          background: darkBackground,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF131720),
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: rickCyan),
        ),
        cardColor: darkSurface,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF121722),
          labelStyle: const TextStyle(color: Color(0xFF8B949E)),
          hintStyle: const TextStyle(color: Color(0xFF485260)),
          prefixIconColor: rickCyan,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF262F40)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF262F40)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: portalGreen, width: 2),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF131720),
          selectedItemColor: portalGreen,
          unselectedItemColor: Color(0xFF6B7280),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
