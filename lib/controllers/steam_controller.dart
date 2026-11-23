import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/steam_asset.dart';
import '../services/steam_market_service.dart';

class SteamController extends GetxController {
  static const String _steamIdKey = 'vaulted_steam_id';

  final RxList<SteamAsset> assets = <SteamAsset>[].obs;
  final RxString steamId = '76561199089584380'.obs;
  final RxBool isRefreshing = false.obs;
  final RxString syncStatus = 'Synced'.obs;

  @override
  void onInit() {
    super.onInit();
    _initSteam();
  }

  Future<void> _initSteam() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_steamIdKey);
    if (saved != null && saved.isNotEmpty) {
      steamId.value = saved;
    }
    assets.assignAll(initialSteamAssets);
    await syncAccount(steamId.value);
  }

  double get totalSteamValue =>
      assets.fold(0.0, (sum, item) => sum + item.priceUsd);

  Future<void> syncAccount(String newSteamId) async {
    final cleanId = newSteamId.trim();
    if (cleanId.isEmpty) return;

    isRefreshing.value = true;
    steamId.value = cleanId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_steamIdKey, cleanId);

    final fetched = await SteamMarketService.fetchSteamInventory(cleanId);
    if (fetched.isNotEmpty) {
      assets.assignAll(fetched);
      syncStatus.value = 'Live Steam Sync (${fetched.length} items)';
    } else {
      assets.assignAll(initialSteamAssets);
      syncStatus.value = 'Fallback Cache (Web CORS / Private)';
    }

    // Update top 5 market prices
    final limit = assets.length > 5 ? 5 : assets.length;
    for (int i = 0; i < limit; i++) {
      final live = await SteamMarketService.fetchLivePrice(assets[i].marketHashName);
      if (live != null) {
        assets[i] = assets[i].copyWith(priceUsd: live);
      }
    }
    isRefreshing.value = false;
  }
}
