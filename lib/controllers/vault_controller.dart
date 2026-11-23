import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/vault_item.dart';
import '../services/api_service.dart';

class VaultController extends GetxController {
  final Box<VaultItem> _box = Hive.box<VaultItem>('vault_items');

  final RxList<VaultItem> items = <VaultItem>[].obs;
  final RxString selectedCurrency = 'IDR'.obs;
  final RxBool isBalanceVisible = true.obs;
  final RxMap<String, double> exchangeRates = <String, double>{
    'USD': 1.0,
    'IDR': 15850.0,
    'EUR': 0.92,
    'JPY': 152.4,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    loadItems();
    fetchLiveRates();
  }

  void loadItems() {
    items.assignAll(_box.values.toList());
  }

  Future<void> fetchLiveRates() async {
    final rates = await ApiService.getExchangeRates();
    exchangeRates.assignAll(rates);
  }

  Future<void> addItem(VaultItem item) async {
    await _box.add(item);
    loadItems();
  }

  Future<void> updateItem(int index, VaultItem item) async {
    await _box.putAt(index, item);
    loadItems();
  }

  Future<void> deleteItem(int index) async {
    await _box.deleteAt(index);
    loadItems();
  }

  double get totalValuation =>
      items.fold(0.0, (sum, item) => sum + item.currentValuation);

  String get currencyPrefix {
    switch (selectedCurrency.value) {
      case 'IDR':
        return 'Rp ';
      case 'EUR':
        return '€';
      case 'JPY':
        return '¥';
      default:
        return '\$';
    }
  }

  String formatRawNumber(double usdAmount) {
    final rate = exchangeRates[selectedCurrency.value] ?? 1.0;
    final converted = usdAmount * rate;
    if (selectedCurrency.value == 'IDR' || selectedCurrency.value == 'JPY') {
      return NumberFormat('#,##0', 'en_US').format(converted);
    }
    return NumberFormat('#,##0.00', 'en_US').format(converted);
  }

  String formatAmount(double usdAmount) =>
      '$currencyPrefix${formatRawNumber(usdAmount)}';
}
