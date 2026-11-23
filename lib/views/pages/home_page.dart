import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/steam_controller.dart';
import '../../controllers/vault_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../../routes/app_routes.dart';
import '../modals/manual_asset_modal.dart';

class HomePage extends StatelessWidget {
  static const Widget _pillarDivider = Divider(
    height: 1,
    thickness: 1,
    color: VaultColors.hairline,
    indent: 68,
    endIndent: 16,
  );

  final String nama;

  HomePage({super.key, required this.nama});

  final VaultController vaultController = Get.find<VaultController>();
  final SteamController steamController = Get.find<SteamController>();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

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
    final now = DateTime.now();

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
                    'assets/images/cloud_sea.png',
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
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.22),
                          Colors.black.withValues(alpha: 0.52),
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
                                letterSpacing: 1.5,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4.5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.90),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Text(
                                DateFormat('MMM d').format(now).toUpperCase(),
                                style: VaultTypography.mono(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: VaultColors.ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Text(
                          '${_getGreeting()}, $nama.',
                          style: VaultTypography.sans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(
                          () => Row(
                            children: [
                              Text(
                                'Today · ${DateFormat('EEEE, d MMMM').format(now)}',
                                style: VaultTypography.sans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => vaultController.isBalanceVisible.toggle(),
                                child: Icon(
                                  vaultController.isBalanceVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 14,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          final visible = vaultController.isBalanceVisible.value;
                          final netWorth = vaultController.totalValuation +
                              steamController.totalSteamValue;
                          final totalCount = vaultController.items.length +
                              steamController.assets.length;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    vaultController.currencyPrefix,
                                    style: VaultTypography.mono(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        visible
                                            ? vaultController.formatRawNumber(netWorth)
                                            : '••••••••',
                                        style: VaultTypography.mono(
                                          fontSize: 38,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.8,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '$totalCount vault items active',
                                style: VaultTypography.sans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.88),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 38),
                        // Frosted Glass Bar with Valto Perched on Top
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () => ManualAssetModal.show(context),
                              child: ClipRRect(
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
                                        Expanded(
                                          child: Text(
                                            'Tap to log asset & warranty...',
                                            style: VaultTypography.sans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white.withValues(alpha: 0.9),
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
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
                    // Currency Switcher Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'RECENT ACTIVITY',
                          style: VaultTypography.mono(
                            fontSize: 10.5,
                            letterSpacing: 1.2,
                            color: VaultColors.ink2,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: VaultColors.cardHover,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: ['IDR', 'USD', 'EUR', 'JPY'].map((curr) {
                                    final isSel =
                                        vaultController.selectedCurrency.value == curr;
                                    return GestureDetector(
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                        vaultController.selectedCurrency.value = curr;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSel ? Colors.white : Colors.transparent,
                                          borderRadius: BorderRadius.circular(7),
                                        ),
                                        child: Text(
                                          curr,
                                          style: VaultTypography.mono(
                                            fontSize: 9.5,
                                            fontWeight:
                                                isSel ? FontWeight.w700 : FontWeight.w500,
                                            color:
                                                isSel ? VaultColors.ink : VaultColors.ink2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.converter),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: VaultColors.cardHover,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: VaultColors.hairline),
                                ),
                                child: const Icon(
                                  Icons.calculate_outlined,
                                  size: 15,
                                  color: VaultColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Dynamic Activity Items from VaultController
                    Obx(() {
                      final list = vaultController.items;
                      if (list.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: Text(
                              'No assets tracked yet. Add an asset to start.',
                              style: VaultTypography.sans(
                                fontSize: 12,
                                color: VaultColors.ink3,
                              ),
                            ),
                          ),
                        );
                      }
                      final count = list.length > 3 ? 3 : list.length;
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
                                final item = list[list.length - 1 - i];
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
                                          Text(item.name, style: VaultTypography.cardLabel),
                                          Text(
                                            '${item.category} · Exp ${item.warrantyExpiryDate}',
                                            style: VaultTypography.cardSub,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      vaultController.formatAmount(item.currentValuation),
                                      style: VaultTypography.mono(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ],
                      );
                    }),
                    const SizedBox(height: 18),

                    // Quick Action Buttons (2-button row, exact original style)
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionTile(
                            icon: Icons.add_circle_outline_rounded,
                            label: 'Add Asset',
                            onTap: () => ManualAssetModal.show(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionTile(
                            icon: Icons.near_me_outlined,
                            label: 'Service Radar',
                            onTap: () => Get.toNamed(AppRoutes.lbs),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // YOUR VAULT SPACES
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
                          Obx(
                            () => _buildPillarRow(
                              icon: Icons.sports_esports_rounded,
                              iconColor: VaultColors.accent,
                              title: 'Steam & Gaming Vault',
                              subtitle: '${steamController.assets.length} CS2 items · Live Steam API',
                              value: vaultController.formatAmount(steamController.totalSteamValue),
                              onTap: () => Get.toNamed(AppRoutes.steam),
                            ),
                          ),
                          _pillarDivider,
                          Obx(
                            () => _buildPillarRow(
                              icon: Icons.laptop_mac_rounded,
                              iconColor: VaultColors.ink,
                              title: 'Hardware & Devices',
                              subtitle: 'Equipment, serials & warranty expiry',
                              value: vaultController.formatAmount(vaultController.totalValuation),
                              onTap: () => Get.toNamed(AppRoutes.inventory),
                            ),
                          ),
                          _pillarDivider,
                          _buildPillarRow(
                            icon: Icons.near_me_rounded,
                            iconColor: VaultColors.ink2,
                            title: 'LBS Care Centers',
                            subtitle: 'Official warranty service radar near you',
                            value: 'Radar',
                            onTap: () => Get.toNamed(AppRoutes.lbs),
                          ),
                          _pillarDivider,
                          _buildPillarRow(
                            icon: Icons.currency_exchange_rounded,
                            iconColor: VaultColors.accent,
                            title: 'Currency & Timezone Exchange',
                            subtitle: 'Live conversion for 4 currencies & 4 zones',
                            value: 'Convert',
                            onTap: () => Get.toNamed(AppRoutes.converter),
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
