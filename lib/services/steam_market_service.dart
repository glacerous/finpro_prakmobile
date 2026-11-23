import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/steam_asset.dart';

class SteamMarketService {
  static final Map<String, double> _priceCache = {};

  static Future<double?> fetchLivePrice(
    String marketHashName, {
    int appId = 730,
  }) async {
    final cacheKey = '${appId}_$marketHashName';
    if (_priceCache.containsKey(cacheKey)) return _priceCache[cacheKey];

    final uri = Uri.parse(
      'https://steamcommunity.com/market/priceoverview/?appid=$appId&currency=1&market_hash_name=${Uri.encodeComponent(marketHashName)}',
    );
    for (int attempt = 0; attempt < 2; attempt++) {
      try {
        final response =
            await http.get(uri).timeout(const Duration(seconds: 5));
        if (response.statusCode == 429 && attempt == 0) {
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final rawPrice = data['lowest_price'] ?? data['median_price'];
          if (data['success'] == true && rawPrice != null) {
            final clean = rawPrice
                .toString()
                .replaceAll('\$', '')
                .replaceAll(',', '')
                .trim();
            final parsed = double.tryParse(clean);
            if (parsed != null) _priceCache[cacheKey] = parsed;
            return parsed;
          }
        }
        break;
      } catch (e) {
        debugPrint('Steam price notice: $e');
        break;
      }
    }
    return null;
  }

  static Future<List<SteamAsset>> fetchSteamInventory(String steamId) async {
    final List<SteamAsset> imported = [];
    const apps = [(730, 2), (753, 6)];

    for (final (appId, contextId) in apps) {
      String? startAssetId;
      while (true) {
        final query = startAssetId != null
            ? 'l=english&count=100&start_assetid=$startAssetId'
            : 'l=english&count=100';
        final url =
            'https://steamcommunity.com/inventory/$steamId/$appId/$contextId?$query';
        try {
          final res =
              await http.get(Uri.parse(url)).timeout(const Duration(seconds: 6));
          if (res.statusCode != 200) break;

          final data = jsonDecode(res.body);
          final assets = data['assets'] as List?;
          final descriptions = data['descriptions'] as List?;
          if (assets == null || descriptions == null) break;

          final descMap = <String, Map<String, dynamic>>{};
          for (final d in descriptions) {
            final key = '${d['classid']}_${d['instanceid']}';
            descMap[key] = Map<String, dynamic>.from(d as Map);
          }

          for (final a in assets) {
            final key = '${a['classid']}_${a['instanceid']}';
            final desc = descMap[key];
            if (desc == null) continue;

            final name = desc['name']?.toString() ?? 'Steam Item';
            final type = desc['type']?.toString() ?? 'Steam Asset';
            final hash = desc['market_hash_name']?.toString() ?? name;
            final icon =
                (desc['icon_url_large'] ?? desc['icon_url'])?.toString();
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
                appId: appId,
                marketable: desc['marketable'] == 1,
              ),
            );
          }

          if (data['more_items'] == 1 && data['last_assetid'] != null) {
            startAssetId = data['last_assetid'].toString();
          } else {
            break;
          }
        } catch (e) {
          debugPrint('Steam inventory fetch notice ($url): $e');
          break;
        }
      }
    }
    return imported;
  }
}
