import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/category_controller.dart';
import '../controller/favorite_controller.dart';
import '../controller/meal_controller.dart';
import '../controller/root_controller.dart';
import '../view/pages/detail_page.dart';
import '../view/pages/login_page.dart';
import '../view/pages/register_page.dart';
import '../view/pages/root_page.dart';
import 'app_routes.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<RootController>(() => RootController());
    Get.lazyPut<MealController>(() => MealController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.root,
      page: () => const RootPage(),
      binding: RootBinding(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DetailPage(),
    ),
  ];
}
