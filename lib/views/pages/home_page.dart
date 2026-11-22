import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../routes/app_routes.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  final String nama;

  HomePage({super.key, required this.nama});

  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        title: Text('Halo, $nama!', style: VaultTypography.sectionTitle),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () => Get.toNamed(AppRoutes.cart),
              icon: Badge(
                label: Text('${cartController.items.length}'),
                isLabelVisible: cartController.items.isNotEmpty,
                backgroundColor: VaultColors.accent,
                child: const Icon(Icons.shopping_bag_outlined, color: VaultColors.ink),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(() {
          if (productController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: VaultColors.accent),
            );
          }
          return GridView.builder(
            itemCount: productController.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final product = productController.products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Get.toNamed(AppRoutes.detail, arguments: product);
                },
              );
            },
          );
        }),
      ),
    );
  }
}
