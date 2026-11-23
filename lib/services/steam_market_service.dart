import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SteamMarketService {
  static Future<double?> fetchLivePrice(String marketHashName) async {
    try {
      final uri = Uri.parse(
        'https://steamcommunity.com/market/priceoverview/?appid=730&currency=1&market_hash_name=${Uri.encodeComponent(marketHashName)}',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['lowest_price'] != null) {
          final raw = data['lowest_price'].toString().replaceAll('\$', '').trim();
          return double.tryParse(raw);
        }
      }
    } catch (e) {
      debugPrint('Steam API fallback notice: $e');
    }
    return null;
  }
}
