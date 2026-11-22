import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../views/pages/cart_page.dart';
import '../views/pages/detail_page.dart';
import '../views/pages/hardware_catalog_page.dart';
import '../views/pages/login_page.dart';
import '../views/pages/root_page.dart';
import 'app_routes.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<CartController>(() => CartController());
  }
}

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController());
  }
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.root,
      page: () => const RootPage(),
      binding: RootBinding(),
    ),
    GetPage(
      name: AppRoutes.catalog,
      page: () => HardwareCatalogPage(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => DetailPage(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => CartPage(),
      binding: CartBinding(),
    ),
  ];
}
