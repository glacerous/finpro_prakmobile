import 'dart:ui';
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
          // Scenic Alpine Dawn Hero Header (exact original VAULTED look)
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/dither_landscape.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.42),
                          Colors.black.withValues(alpha: 0.25),
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 42),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar: VAULTED wordmark + Cart pill
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'VAULTED',
                              style: VaultTypography.mono(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.8,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => GestureDetector(
                                onTap: () => Get.toNamed(AppRoutes.cart),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 11,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 15,
                                        color: VaultColors.ink,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'BAG (${cartController.items.length})',
                                        style: VaultTypography.mono(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                          color: VaultColors.ink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Selamat datang, $nama.',
                          style: VaultTypography.sans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.7),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          final totalValue = productController.products.fold<double>(
                            0,
                            (sum, p) => sum + p.price,
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '\$',
                                    style: VaultTypography.mono(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    totalValue.toStringAsFixed(0),
                                    style: VaultTypography.mono(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.8,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withValues(alpha: 0.7),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${productController.products.length} curated timepieces active',
                                style: VaultTypography.sans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.88),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 28),
                        // Frosted Glass Bar with Valto Perched on Top
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                child: Container(
                                  height: 46,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.38),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.watch_outlined,
                                        size: 16,
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Valto Curated Watch Market',
                                        style: VaultTypography.sans(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              right: 12,
                              top: -26,
                              child: ValtoMascot(size: 46, mood: ValtoMood.playful),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Overlapping Rounded Porcelain Sheet
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: VaultColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('LUXURY COLLECTION',
                        style: VaultTypography.mono(
                          fontSize: 11,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                          color: VaultColors.ink2,
                        )),
                    Text('DUMMYJSON API',
                        style: VaultTypography.mono(
                          fontSize: 10,
                          color: VaultColors.accentWarm,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
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
