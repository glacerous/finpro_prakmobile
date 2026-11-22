import 'package:get/get.dart';
import '../models/product.dart';

class CartController extends GetxController {
  final RxList<Product> _items = <Product>[].obs;

  List<Product> get items => _items;
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  void addToCart(Product product) {
    _items.add(product);
  }

  void removeFromCart(int index) {
    _items.removeAt(index);
  }
}
