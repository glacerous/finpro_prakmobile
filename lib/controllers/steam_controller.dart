import 'package:get/get.dart';
import '../models/steam_asset.dart';
import '../services/steam_market_service.dart';

class SteamController extends GetxController {
  final RxList<SteamAsset> assets = <SteamAsset>[].obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    assets.assignAll(initialSteamAssets);
    refreshLivePrices();
  }

  double get totalSteamValue =>
      assets.fold(0.0, (sum, item) => sum + item.priceUsd);

  Future<void> refreshLivePrices() async {
    isRefreshing.value = true;
    for (int i = 0; i < assets.length; i++) {
      final live = await SteamMarketService.fetchLivePrice(assets[i].marketHashName);
      if (live != null) {
        assets[i] = assets[i].copyWith(priceUsd: live);
      }
    }
    isRefreshing.value = false;
  }
}
