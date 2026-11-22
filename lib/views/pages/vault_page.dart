import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../models/vault_item.dart';
import 'add_vault_item_page.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        title: Text('Brankas Lokal', style: VaultTypography.sectionTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<VaultItem>('vault_items').listenable(),
          builder: (context, box, child) {
            if (box.isEmpty) {
              return Center(
                child: Text(
                  'Belum ada aset di brankas.',
                  style: VaultTypography.cardSub,
                ),
              );
            }
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final item = box.getAt(index);
                if (item == null) return const SizedBox.shrink();
                return Card(
                  color: VaultColors.card,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: VaultColors.hairline),
                  ),
                  child: ListTile(
                    title: Text(item.title, style: VaultTypography.cardLabel),
                    subtitle: Text(item.subtitle, style: VaultTypography.cardSub),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: VaultColors.accent),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddVaultItemPage(index: index, item: item),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: VaultColors.neg),
                          onPressed: () => box.deleteAt(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: VaultColors.primaryButton,
        foregroundColor: VaultColors.primaryButtonInk,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddVaultItemPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
