import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../routes/app_routes.dart';

class HardwareCatalogPage extends StatelessWidget {
  HardwareCatalogPage({super.key});

  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        title: Text('Hardware & Devices', style: VaultTypography.sectionTitle),
      ),
      body: Obx(() {
        if (productController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: VaultColors.accent),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            final product = productController.products[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: VaultColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: VaultColors.hairline),
              ),
              child: ListTile(
                onTap: () => Get.toNamed(AppRoutes.detail, arguments: product),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.images.isNotEmpty ? product.images[0] : '',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(Icons.laptop_mac),
                  ),
                ),
                title: Text(product.title, style: VaultTypography.cardLabel),
                subtitle: Text(
                  'Est. \$${product.price} · ★ ${product.rating}',
                  style: VaultTypography.mono(fontSize: 11.5, color: VaultColors.ink2),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: VaultColors.ink3,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
