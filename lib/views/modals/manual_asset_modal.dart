import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/vault_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../models/vault_item.dart';

class ManualAssetModal {
  static void show(BuildContext context, {int? editIndex, VaultItem? editItem}) {
    final vaultController = Get.find<VaultController>();
    final nameCtrl = TextEditingController(text: editItem?.name ?? '');
    final priceCtrl = TextEditingController(
      text: editItem != null ? editItem.currentValuation.toStringAsFixed(0) : '',
    );
    final serialCtrl = TextEditingController(text: editItem?.serialNumber ?? '');
    final warrantyCtrl = TextEditingController(text: '12');
    String selectedCategory = editItem?.category ?? 'Hardware';

    InputDecoration inputDeco(String hint, {String? prefix}) => InputDecoration(
          prefixText: prefix,
          prefixStyle: prefix != null
              ? VaultTypography.sans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: VaultColors.ink,
                )
              : null,
          hintText: hint,
          hintStyle: VaultTypography.sans(fontSize: 13, color: VaultColors.ink3),
          filled: true,
          fillColor: VaultColors.cardHover,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        );

    Widget fieldLabel(String text) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            text,
            style: VaultTypography.mono(
              fontSize: 10,
              letterSpacing: 1,
              color: VaultColors.ink2,
            ),
          ),
        );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: VaultColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: VaultColors.hairline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: VaultColors.badgeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_box_rounded,
                            color: VaultColors.accent,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              editItem == null ? 'NEW ASSET ENTRY' : 'EDIT ASSET',
                              style: VaultTypography.mono(
                                fontSize: 10,
                                letterSpacing: 1.1,
                                color: VaultColors.accent,
                              ),
                            ),
                            Text(
                              editItem == null ? 'Add High-Value Item' : 'Update Vault Item',
                              style: VaultTypography.sans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: VaultColors.ink2),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                fieldLabel('CATEGORY'),
                Row(
                  children: ['Hardware', 'Gadget', 'Peripheral'].map((cat) {
                    final sel = selectedCategory == cat;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setModalState(() => selectedCategory = cat);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: sel ? VaultColors.ink : VaultColors.cardHover,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cat,
                            style: VaultTypography.sans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sel ? Colors.white : VaultColors.ink2,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                fieldLabel('DEVICE / ASSET NAME'),
                TextField(
                  controller: nameCtrl,
                  decoration: inputDeco('e.g. MacBook Pro M3 / RTX 4090'),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          fieldLabel('VALUATION (USD)'),
                          TextField(
                            controller: priceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: inputDeco('1500', prefix: '\$ '),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          fieldLabel('WARRANTY (MONTHS)'),
                          TextField(
                            controller: warrantyCtrl,
                            keyboardType: TextInputType.number,
                            decoration: inputDeco('12'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                fieldLabel('SERIAL NUMBER (OPTIONAL)'),
                TextField(
                  controller: serialCtrl,
                  decoration: inputDeco('e.g. SN-9920-VAULT'),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) {
                        VaultToast.show(
                          context,
                          icon: Icons.error_outline_rounded,
                          iconColor: VaultColors.neg,
                          message: 'Nama perangkat wajib diisi.',
                        );
                        return;
                      }
                      final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
                      final months = int.tryParse(warrantyCtrl.text.trim()) ?? 12;
                      final now = DateTime.now();
                      final expiry = DateTime(now.year, now.month + months, now.day);
                      final df = DateFormat('yyyy-MM-dd');

                      final newItem = VaultItem(
                        name: name,
                        category: selectedCategory,
                        purchasePrice: price,
                        currentValuation: price,
                        purchaseDate: editItem?.purchaseDate ?? df.format(now),
                        warrantyExpiryDate: df.format(expiry),
                        serialNumber: serialCtrl.text.trim(),
                      );

                      if (editIndex != null) {
                        await vaultController.updateItem(editIndex, newItem);
                      } else {
                        await vaultController.addItem(newItem);
                      }
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) {
                        VaultToast.show(
                          context,
                          icon: Icons.verified_user_outlined,
                          message: '$name tersimpan di Vault!',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VaultColors.primaryButton,
                      foregroundColor: VaultColors.primaryButtonInk,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      editItem == null ? 'Save to Vault' : 'Update Vault Item',
                      style: VaultTypography.sans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
