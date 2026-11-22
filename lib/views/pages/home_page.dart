import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../../models/vault_item.dart';
import '../../routes/app_routes.dart';
import '../widgets/product_card.dart';
import 'add_vault_item_page.dart';

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
          // Scenic Alpine Dawn Hero Header
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
                                        Icons.verified_user_outlined,
                                        size: 15,
                                        color: VaultColors.ink,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'AUDIT (${cartController.items.length})',
                                        style: VaultTypography.mono(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.6,
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
                          ),
                        ),
                        const SizedBox(height: 12),
                        ValueListenableBuilder(
                          valueListenable: Hive.box<VaultItem>('vault_items').listenable(),
                          builder: (context, box, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${box.length} Perangkat',
                                  style: VaultTypography.mono(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.8,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Garansi aktif tersimpan di brankas lokal',
                                  style: VaultTypography.sans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.88),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        // Frosted Glass Sentinel Bar with Valto Perched on Top
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
                                        Icons.shield_outlined,
                                        size: 16,
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Valto Warranty Sentinel · Active',
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
                              child: ValtoMascot(size: 46, mood: ValtoMood.vigilant),
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
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // My Warranty Vault Quick Card
                    ValueListenableBuilder(
                      valueListenable: Hive.box<VaultItem>('vault_items').listenable(),
                      builder: (context, box, _) {
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: VaultColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: VaultColors.hairline),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: VaultColors.badgeBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_outlined,
                                  color: VaultColors.accentWarm,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Brankas Garansi Saya', style: VaultTypography.cardLabel),
                                    Text(
                                      box.isEmpty
                                          ? 'Belum ada perangkat terdaftar'
                                          : '${box.getAt(box.length - 1)?.title ?? ''} (${box.length} total)',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: VaultTypography.cardSub,
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AddVaultItemPage()),
                                ),
                                child: Text(
                                  '+ TAMBAH',
                                  style: VaultTypography.mono(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: VaultColors.accentWarm,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'REFERENSI HARDWARE (API)',
                          style: VaultTypography.mono(
                            fontSize: 11,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w700,
                            color: VaultColors.ink2,
                          ),
                        ),
                        Text(
                          'LAPTOPS',
                          style: VaultTypography.mono(
                            fontSize: 10,
                            color: VaultColors.accentWarm,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tech Hardware Grid
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
