import 'package:get/get.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final RxList<Product> _products = <Product>[].obs;
  final RxBool _isLoading = false.obs;

  List<Product> get products => _products;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    _retrieveData();
    super.onInit();
  }

  Future<void> _retrieveData() async {
    try {
      _isLoading.value = true;
      final data = await ApiService.getProducts();
      _products.assignAll(data);
    } finally {
      _isLoading.value = false;
    }
  }
}
