import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
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
      body: CustomScrollView(
        slivers: [
          // Top 25% Glance Header (Alpine Dawn Aesthetic)
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.16,
                    child: Image.asset(
                      'assets/images/dither_landscape.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        VaultColors.sunsetTop.withValues(alpha: 0.85),
                        VaultColors.background,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const ValtoMascot(size: 40, mood: ValtoMood.playful),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VAULTED MARKET',
                                  style: VaultTypography.mono(
                                    fontSize: 10,
                                    letterSpacing: 1.4,
                                    color: VaultColors.accentWarm,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text('Halo, $nama', style: VaultTypography.sectionTitle),
                              ],
                            ),
                          ),
                          Obx(
                            () => IconButton(
                              onPressed: () => Get.toNamed(AppRoutes.cart),
                              icon: Badge(
                                label: Text('${cartController.items.length}'),
                                isLabelVisible: cartController.items.isNotEmpty,
                                backgroundColor: VaultColors.accent,
                                child: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: VaultColors.ink,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Obx(
                        () => Row(
                          children: [
                            Text(
                              '${productController.products.length}',
                              style: VaultTypography.heroTotal.copyWith(fontSize: 26),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Curated Assets Live',
                              style: VaultTypography.cardSub,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Product Grid
          Obx(() {
            if (productController.isLoading) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: VaultColors.accent),
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = productController.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Get.toNamed(AppRoutes.detail, arguments: product),
                    );
                  },
                  childCount: productController.products.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.74,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
