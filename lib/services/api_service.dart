import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String apiUrl = 'https://dummyjson.com/products';
  static const String ratesUrl = 'https://open.er-api.com/v6/latest/USD';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$apiUrl/category/laptops'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List rawList = data['products'];
      return rawList.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load hardware catalog');
    }
  }

  static Future<Map<String, double>> getExchangeRates() async {
    try {
      final response = await http.get(Uri.parse(ratesUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        return {
          'USD': 1.0,
          'IDR': (rates['IDR'] as num? ?? 15850.0).toDouble(),
          'EUR': (rates['EUR'] as num? ?? 0.92).toDouble(),
          'JPY': (rates['JPY'] as num? ?? 152.4).toDouble(),
        };
      }
    } catch (_) {}
    return {'USD': 1.0, 'IDR': 15850.0, 'EUR': 0.92, 'JPY': 152.4};
  }
}
