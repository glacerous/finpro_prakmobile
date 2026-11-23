import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/steam_controller.dart';
import '../../controllers/vault_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/vault_back_button.dart';

class SteamVaultScreen extends StatelessWidget {
  SteamVaultScreen({super.key});

  final SteamController steamController = Get.find<SteamController>();
  final VaultController vaultController = Get.find<VaultController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        leading: const VaultBackButton(),
        title: Text('Steam & Gaming Vault', style: VaultTypography.sectionTitle),
        actions: [
          Obx(
            () => IconButton(
              icon: steamController.isRefreshing.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: VaultColors.accent,
                      ),
                    )
                  : const Icon(Icons.refresh_rounded, color: VaultColors.ink),
              onPressed: steamController.isRefreshing.value
                  ? null
                  : steamController.refreshLivePrices,
            ),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: VaultColors.ink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STEAM COMMUNITY MARKET',
                      style: VaultTypography.mono(
                        fontSize: 10,
                        letterSpacing: 1.4,
                        color: VaultColors.accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      vaultController.formatAmount(steamController.totalSteamValue),
                      style: VaultTypography.mono(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${steamController.assets.length} CS2 items synced',
                      style: VaultTypography.sans(fontSize: 11, color: VaultColors.ink3),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: steamController.assets.length,
                itemBuilder: (context, index) {
                  final item = steamController.assets[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: VaultColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: VaultColors.hairline),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: VaultColors.cardHover,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.sports_esports_rounded,
                              color: VaultColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: VaultTypography.cardLabel),
                              Text(item.category, style: VaultTypography.cardSub),
                            ],
                          ),
                        ),
                        Text(
                          vaultController.formatAmount(item.priceUsd),
                          style: VaultTypography.mono(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
