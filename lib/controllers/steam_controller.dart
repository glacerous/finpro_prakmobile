import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/steam_asset.dart';
import '../services/steam_market_service.dart';

class SteamController extends GetxController {
  static const String _steamIdKey = 'vaulted_steam_id';
  static const String _defaultSteamId = '76561199089584380';

  final RxList<SteamAsset> assets = <SteamAsset>[].obs;
  final RxString steamId = ''.obs;
  final RxBool isRefreshing = false.obs;
  final RxString syncStatus = 'Synced'.obs;

  @override
  void onInit() {
    super.onInit();
    _initSteam();
  }

  // baca steam id tersimpan dari sharedpreferences, pakai default cuma pas pertama kali install
  Future<void> _initSteam() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_steamIdKey);
    final targetId =
        (saved != null && saved.isNotEmpty) ? saved : _defaultSteamId;
    await syncAccount(targetId);
  }

  double get totalSteamValue =>
      assets.fold(0.0, (sum, item) => sum + item.priceUsd);

  // simpan steam id baru lalu fetch inventory + harga cs2 secara paralel
  Future<void> syncAccount(String newSteamId) async {
    final cleanId = newSteamId.trim();
    if (cleanId.isEmpty) return;

    isRefreshing.value = true;
    steamId.value = cleanId;
    syncStatus.value = 'Syncing CS2 inventory...';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_steamIdKey, cleanId);

    final results = await Future.wait([
      SteamMarketService.fetchSteamInventory(cleanId),
      SteamMarketService.fetchBulkCs2Prices(),
    ]);
    final fetched = results[0] as List<SteamAsset>;
    final priceMap = results[1] as Map<String, double>;

    if (fetched.isNotEmpty) {
      final priced = fetched.map((item) {
        if (!item.marketable) return item;
        final usd = priceMap[item.marketHashName];
        return usd != null ? item.copyWith(priceUsd: usd) : item;
      }).toList();
      assets.assignAll(priced);
      syncStatus.value = 'Live CS2 Sync (${priced.length} items)';
    } else {
      assets.assignAll(initialSteamAssets);
      syncStatus.value = 'Fallback Cache (Web CORS / Private)';
    }

    isRefreshing.value = false;
  }
}
