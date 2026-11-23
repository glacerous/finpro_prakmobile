import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/vault_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../../core/widgets/vault_back_button.dart';
import '../modals/manual_asset_modal.dart';

class InventoryScreen extends StatelessWidget {
  InventoryScreen({super.key});

  final VaultController vaultController = Get.find<VaultController>();

  bool _isExpiringSoon(String expiryDate) {
    try {
      final dt = DateTime.parse(expiryDate);
      return dt.difference(DateTime.now()).inDays <= 60;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        leading: const VaultBackButton(),
        title: Text('Hardware & Devices', style: VaultTypography.sectionTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: VaultColors.ink),
            onPressed: () => ManualAssetModal.show(context),
          ),
        ],
      ),
      body: Obx(() {
        final items = vaultController.items;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: VaultColors.ink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL HARDWARE VALUATION',
                            style: VaultTypography.mono(
                              fontSize: 10,
                              letterSpacing: 1.4,
                              color: VaultColors.accent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            vaultController.formatAmount(vaultController.totalValuation),
                            style: VaultTypography.mono(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${items.length} perangkat terdaftar di vault',
                            style: VaultTypography.sans(fontSize: 11, color: VaultColors.ink3),
                          ),
                        ],
                      ),
                    ),
                    const ValtoMascot(size: 54, mood: ValtoMood.vigilant),
                  ],
                ),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ValtoMascot(size: 72, mood: ValtoMood.sleeping),
                          const SizedBox(height: 12),
                          Text('Belum ada perangkat.', style: VaultTypography.cardLabel),
                          const SizedBox(height: 4),
                          Text('Tekan tombol di bawah untuk tambah.', style: VaultTypography.cardSub),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final expiring = _isExpiringSoon(item.warrantyExpiryDate);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: VaultColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: VaultColors.hairline),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: expiring ? VaultColors.warnBg : VaultColors.posBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.laptop_mac_rounded,
                                  size: 20,
                                  color: expiring ? VaultColors.warn : VaultColors.pos,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: VaultTypography.cardLabel),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item.category} · Exp: ${item.warrantyExpiryDate}',
                                      style: VaultTypography.cardSub,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      vaultController.formatAmount(item.currentValuation),
                                      style: VaultTypography.mono(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: VaultColors.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 19, color: VaultColors.accent),
                                onPressed: () => ManualAssetModal.show(
                                  context,
                                  editIndex: index,
                                  editItem: item,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 19, color: VaultColors.neg),
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  vaultController.deleteItem(index);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => ManualAssetModal.show(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Hardware / Warranty'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VaultColors.primaryButton,
                    foregroundColor: VaultColors.primaryButtonInk,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
