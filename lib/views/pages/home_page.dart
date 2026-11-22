import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../../models/vault_item.dart';
import '../../routes/app_routes.dart';
import 'add_vault_item_page.dart';
import 'lbs_page.dart';
import 'vault_page.dart';

class HomePage extends StatelessWidget {
  final String nama;

  HomePage({super.key, required this.nama});

  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: VaultColors.cardHover,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VaultColors.hairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: VaultColors.ink),
            const SizedBox(width: 8),
            Text(label, style: VaultTypography.cardLabel),
          ],
        ),
      ),
    );
  }

  Widget _buildPillarRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: VaultColors.hairline),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: VaultTypography.cardLabel),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: VaultTypography.cardSub,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: VaultTypography.mono(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: VaultColors.accentWarm,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, size: 18, color: VaultColors.ink3),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. SCENIC ALPINE DAWN HEADER
            Stack(
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
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 54),
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
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Text(
                                    'WISHLIST (${cartController.items.length})',
                                    style: VaultTypography.mono(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: VaultColors.ink,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
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
                                    fontSize: 36,
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
                        const SizedBox(height: 38),
                        // Frosted Glass Bar with Valto Perched on Top
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(26),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.42),
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
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              top: -38,
                              right: 24,
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

            // 2. MAIN WHITE SHEET (Seamlessly Overlapping Scenic Header)
            Transform.translate(
              offset: const Offset(0, -32),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 20,
                      offset: Offset(0, -6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECENT ACTIVITY',
                      style: VaultTypography.mono(
                        fontSize: 10.5,
                        letterSpacing: 1.2,
                        color: VaultColors.ink2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dynamic Activity Items from Hive
                    ValueListenableBuilder(
                      valueListenable: Hive.box<VaultItem>('vault_items').listenable(),
                      builder: (context, box, _) {
                        if (box.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Center(
                              child: Text(
                                'Belum ada garansi terdaftar. Tambah aset untuk mulai.',
                                style: VaultTypography.sans(
                                  fontSize: 12,
                                  color: VaultColors.ink3,
                                ),
                              ),
                            ),
                          );
                        }
                        final count = box.length > 3 ? 3 : box.length;
                        return Column(
                          children: [
                            for (int i = 0; i < count; i++) ...[
                              if (i > 0)
                                const Divider(
                                  height: 18,
                                  thickness: 1,
                                  color: VaultColors.hairline,
                                ),
                              Builder(
                                builder: (_) {
                                  final item = box.getAt(box.length - 1 - i)!;
                                  return Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: VaultColors.posBg,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.verified_user_outlined,
                                          size: 18,
                                          color: VaultColors.pos,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.title, style: VaultTypography.cardLabel),
                                            Text(item.subtitle, style: VaultTypography.cardSub),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    // Quick Action Buttons (2-button row, exact original style)
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionTile(
                            icon: Icons.add_circle_outline_rounded,
                            label: 'Add Asset',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AddVaultItemPage()),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionTile(
                            icon: Icons.near_me_outlined,
                            label: 'Service Radar',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LbsPage(showBack: true)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // YOUR VAULT SPACES (Exact Original Pillar Container)
                    Text(
                      'YOUR VAULT SPACES',
                      style: VaultTypography.mono(
                        fontSize: 10.5,
                        letterSpacing: 1.2,
                        color: VaultColors.ink2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: VaultColors.cardHover,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: VaultColors.hairline),
                      ),
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: Hive.box<VaultItem>('vault_items').listenable(),
                            builder: (context, box, _) => _buildPillarRow(
                              icon: Icons.lock_outline_rounded,
                              iconColor: VaultColors.accent,
                              title: 'My Warranty Vault',
                              subtitle: 'Perangkat & masa berlaku garansi',
                              value: '${box.length} Items',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const VaultPage(showBack: true)),
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: VaultColors.hairline,
                            indent: 68,
                            endIndent: 16,
                          ),
                          Obx(
                            () => _buildPillarRow(
                              icon: Icons.laptop_mac_rounded,
                              iconColor: VaultColors.ink,
                              title: 'Hardware & Devices',
                              subtitle: 'Referensi spek & estimasi harga',
                              value: '${productController.products.length} Live',
                              onTap: () => Get.toNamed(AppRoutes.catalog),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: VaultColors.hairline,
                            indent: 68,
                            endIndent: 16,
                          ),
                          _buildPillarRow(
                            icon: Icons.near_me_rounded,
                            iconColor: VaultColors.ink2,
                            title: 'Service Center Resmi',
                            subtitle: 'Service center terdekat & pengingat klaim',
                            value: 'Radar',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LbsPage(showBack: true)),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: VaultColors.hairline,
                            indent: 68,
                            endIndent: 16,
                          ),
                          Obx(
                            () => _buildPillarRow(
                              icon: Icons.bookmark_border_rounded,
                              iconColor: VaultColors.pos,
                              title: 'Device Wishlist',
                              subtitle: 'Daftar perangkat incaran & estimasi harga',
                              value: '${cartController.items.length} Saved',
                              onTap: () => Get.toNamed(AppRoutes.cart),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
