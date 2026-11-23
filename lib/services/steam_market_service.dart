import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/steam_asset.dart';

class SteamMarketService {
  static final Map<String, double> _priceCache = {};

  // ambil semua harga item cs2 sekaligus biar ga kena rate limit 429 dari steam
  static Future<Map<String, double>> fetchBulkCs2Prices() async {
    if (_priceCache.isNotEmpty) return _priceCache;
    try {
      final res = await http
          .get(Uri.parse('https://csfloat.com/api/v1/listings/price-list'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        for (final entry in list) {
          final name = entry['market_hash_name']?.toString();
          final cents = entry['min_price'];
          if (name != null && cents is num) {
            _priceCache[name] = cents / 100.0; // min_price dari csfloat masih dalam sen usd
          }
        }
      }
    } catch (e) {
      debugPrint('Bulk price fetch notice: $e');
    }
    return _priceCache;
  }

  // ambil inventory cs2 (appid 730, context 2) dibatasi 200 item biar load cepat
  static Future<List<SteamAsset>> fetchSteamInventory(String steamId) async {
    final url =
        'https://steamcommunity.com/inventory/$steamId/730/2?l=english&count=200';
    try {
      final res =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return [];

      final data = jsonDecode(res.body);
      final assets = data['assets'] as List?;
      final descriptions = data['descriptions'] as List?;
      if (assets == null || descriptions == null || assets.isEmpty) return [];

      // steam pisah array assets dan descriptions, jadi di-map dulu pakai classid_instanceid
      final descMap = <String, Map<String, dynamic>>{};
      for (final d in descriptions) {
        final key = '${d['classid']}_${d['instanceid']}';
        descMap[key] = Map<String, dynamic>.from(d as Map);
      }

      final imported = <SteamAsset>[];
      for (final a in assets) {
        final key = '${a['classid']}_${a['instanceid']}';
        final desc = descMap[key];
        if (desc == null) continue;

        final name = desc['name']?.toString() ?? 'Steam Item';
        final type = desc['type']?.toString() ?? 'Steam Asset';
        final hash = desc['market_hash_name']?.toString() ?? name;
        final icon = (desc['icon_url_large'] ?? desc['icon_url'])?.toString();
        final imageUrl = (icon != null && icon.isNotEmpty)
            ? 'https://community.steamstatic.com/economy/image/$icon'
            : 'https://community.cloudflare.steamstatic.com/public/images/apps/730/default.png';

        imported.add(
          SteamAsset(
            name: name,
            category: 'Steam / $type',
            marketHashName: hash,
            imageUrl: imageUrl,
            priceUsd: 0.0,
            appId: 730,
            marketable: desc['marketable'] == 1,
          ),
        );
      }
      return imported;
    } catch (e) {
      debugPrint('Steam inventory fetch notice ($url): $e');
      return [];
    }
  }
}
