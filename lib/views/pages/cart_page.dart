import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        title: Text('Prioritas Audit Garansi', style: VaultTypography.sectionTitle),
      ),
      body: Obx(() {
        if (cartController.items.isEmpty) {
          return Center(
            child: Text('Belum ada perangkat di daftar audit.', style: VaultTypography.cardSub),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.items.length,
                itemBuilder: (context, index) {
                  final item = cartController.items[index];
                  return Card(
                    color: VaultColors.card,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: VaultColors.hairline),
                    ),
                    child: ListTile(
                      leading: Image.network(
                        item.images.isNotEmpty ? item.images[0] : '',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(Icons.laptop_mac),
                      ),
                      title: Text(item.title, style: VaultTypography.cardLabel),
                      subtitle: Text(
                        'Est. \$${item.price}',
                        style: VaultTypography.mono(fontSize: 12, color: VaultColors.ink2),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: VaultColors.neg),
                        onPressed: () => cartController.removeFromCart(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: VaultColors.card,
                border: Border(top: BorderSide(color: VaultColors.hairline)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Valuasi Audit', style: VaultTypography.cardLabel),
                  Text(
                    '\$${cartController.totalPrice.toStringAsFixed(2)}',
                    style: VaultTypography.mono(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: VaultColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
