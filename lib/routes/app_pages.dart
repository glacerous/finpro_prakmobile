import 'package:get/get.dart';
import '../controllers/steam_controller.dart';
import '../controllers/vault_controller.dart';
import '../views/pages/inventory_screen.dart';
import '../views/pages/login_page.dart';
import '../views/pages/root_page.dart';
import '../views/pages/steam_vault_screen.dart';
import '../views/pages/vault_converter_screen.dart';
import '../views/pages/warranty_lbs_screen.dart';
import 'app_routes.dart';

// binding otomatis inject controller sebelum halaman root dibuka
class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaultController>(() => VaultController());
    Get.lazyPut<SteamController>(() => SteamController());
  }
}

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.root, page: () => const RootPage(), binding: RootBinding()),
    GetPage(name: AppRoutes.steam, page: () => SteamVaultScreen()),
    GetPage(name: AppRoutes.inventory, page: () => InventoryScreen()),
    GetPage(name: AppRoutes.lbs, page: () => const WarrantyLbsScreen(showBack: true)),
    GetPage(name: AppRoutes.converter, page: () => const VaultConverterScreen()),
  ];
}
