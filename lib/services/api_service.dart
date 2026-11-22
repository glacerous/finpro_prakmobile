import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String apiUrl = 'https://dummyjson.com/products';

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

  static Future<Product> getSingleProduct(int productId) async {
    final response = await http.get(Uri.parse('$apiUrl/$productId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load hardware details');
    }
  }
}
