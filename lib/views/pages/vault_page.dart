import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../../models/vault_item.dart';
import 'add_vault_item_page.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<VaultItem>('vault_items').listenable(),
          builder: (context, box, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top 25% Glance Only: Dark Luxury Portfolio Summary Card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                                'LOCAL HIVE VAULT',
                                style: VaultTypography.mono(
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                  color: VaultColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${box.length} Aset Tersimpan',
                                style: VaultTypography.mono(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Offline-first encrypted box',
                                style: VaultTypography.sans(
                                  fontSize: 11,
                                  color: VaultColors.ink3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const ValtoMascot(size: 56, mood: ValtoMood.vigilant),
                      ],
                    ),
                  ),
                ),
                // Asset List
                Expanded(
                  child: box.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const ValtoMascot(size: 72, mood: ValtoMood.sleeping),
                              const SizedBox(height: 12),
                              Text(
                                'Brankas masih kosong.',
                                style: VaultTypography.cardLabel,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tekan tombol di bawah untuk simpan aset.',
                                style: VaultTypography.cardSub,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            final item = box.getAt(index);
                            if (item == null) return const SizedBox.shrink();
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: VaultColors.card,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: VaultColors.hairline),
                              ),
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: VaultColors.badgeBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.verified_user_outlined,
                                    color: VaultColors.accentWarm,
                                    size: 20,
                                  ),
                                ),
                                title: Text(item.title, style: VaultTypography.cardLabel),
                                subtitle: Text(item.subtitle, style: VaultTypography.cardSub),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: VaultColors.accent,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                AddVaultItemPage(index: index, item: item),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: VaultColors.neg,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        box.deleteAt(index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // Bottom 40% Thumb Touch CTA
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddVaultItemPage()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Simpan Aset ke Brankas'),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
