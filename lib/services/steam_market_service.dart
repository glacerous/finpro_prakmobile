import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/steam_asset.dart';

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
      debugPrint('Steam price notice: $e');
    }
    return null;
  }

  static Future<List<SteamAsset>> fetchSteamInventory(String steamId) async {
    final List<SteamAsset> imported = [];
    final endpoints = [
      'https://steamcommunity.com/inventory/$steamId/730/2?l=english&count=50',
      'https://steamcommunity.com/inventory/$steamId/753/6?l=english&count=50',
    ];

    for (final url in endpoints) {
      try {
        final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          final descriptions = data['descriptions'] as List?;
          if (descriptions != null) {
            for (final desc in descriptions) {
              final name = desc['name']?.toString() ?? 'Steam Item';
              final type = desc['type']?.toString() ?? 'Steam Asset';
              final hash = desc['market_hash_name']?.toString() ?? name;
              final icon = (desc['icon_url_large'] ?? desc['icon_url'])?.toString();
              final imageUrl = (icon != null && icon.isNotEmpty)
                  ? 'https://community.steamstatic.com/economy/image/$icon'
                  : 'https://community.cloudflare.steamstatic.com/public/images/apps/730/default.png';

              double price = 1.50;
              if (name.contains('Case')) price = 0.45;
              if (name.contains('Covert') || name.contains('Knife')) price = 85.0;

              imported.add(
                SteamAsset(
                  name: name,
                  category: 'Steam / $type',
                  marketHashName: hash,
                  imageUrl: imageUrl,
                  priceUsd: price,
                ),
              );
            }
          }
        }
      } catch (e) {
        debugPrint('Steam inventory fetch notice ($url): $e');
      }
    }
    return imported;
  }
}
