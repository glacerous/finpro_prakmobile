import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/vault_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/vault_back_button.dart';
import '../../models/product.dart';
import '../../models/vault_item.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key});

  final Product? productArg = Get.arguments as Product?;
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    if (productArg == null) {
      return Scaffold(
        backgroundColor: VaultColors.background,
        appBar: AppBar(
          backgroundColor: VaultColors.background,
          elevation: 0,
          leading: const VaultBackButton(),
          title: Text('Detail Perangkat', style: VaultTypography.sectionTitle),
        ),
        body: Center(
          child: Text('Data perangkat tidak tersedia.', style: VaultTypography.cardSub),
        ),
      );
    }
    final product = productArg!;

    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        leading: const VaultBackButton(),
        title: Text('Detail Perangkat', style: VaultTypography.sectionTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 220,
                    child: product.images.length > 1
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: product.images.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 10),
                            itemBuilder: (_, index) => Card(
                              color: VaultColors.card,
                              elevation: 0,
                              child: Image.network(product.images[index]),
                            ),
                          )
                        : Center(
                            child: Image.network(
                              product.images.isNotEmpty ? product.images[0] : '',
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(product.title, style: VaultTypography.sectionTitle.copyWith(fontSize: 20)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Est. \$${product.price}',
                        style: VaultTypography.mono(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: VaultColors.accent,
                        ),
                      ),
                      Text('★ ${product.rating}', style: VaultTypography.mono(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Brand: ${product.brand.isEmpty ? product.category : product.brand}',
                      style: VaultTypography.cardSub),
                  const SizedBox(height: 12),
                  Text(product.description, style: VaultTypography.cardDescription),
                  if (product.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: product.tags
                          .map((tag) => Chip(label: Text('$tag')))
                          .toList(),
                    ),
                  ],
                  if (product.reviews.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Catatan Pengguna', style: VaultTypography.sectionTitle),
                    ...product.reviews.map((review) {
                      final name = review['reviewerName']?.toString() ?? 'User';
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: VaultColors.badgeBg,
                          child: Text(name.substring(0, 1)),
                        ),
                        title: Text(name, style: VaultTypography.cardLabel),
                        subtitle: Text('${review['comment'] ?? ''}'),
                        trailing: Text('${review['rating']} ★'),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
          // Bottom Thumb Zone Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final now = DateTime.now();
                      final exp = DateTime(now.year + 1, now.month, now.day);
                      final df = DateFormat('yyyy-MM-dd');
                      Get.find<VaultController>().addItem(
                        VaultItem(
                          name: product.title,
                          category: 'Hardware',
                          purchasePrice: product.price,
                          currentValuation: product.price,
                          purchaseDate: df.format(now),
                          warrantyExpiryDate: df.format(exp),
                        ),
                      );
                      VaultToast.show(
                        context,
                        icon: Icons.verified_user_outlined,
                        message: '${product.title} didaftarkan ke Garansi',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: VaultColors.hairline),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Daftarkan Garansi',
                      style: VaultTypography.sans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: VaultColors.ink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cartController.addToCart(product);
                      VaultToast.show(
                        context,
                        icon: Icons.bookmark_added_outlined,
                        message: '${product.title} masuk Wishlist',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VaultColors.primaryButton,
                      foregroundColor: VaultColors.primaryButtonInk,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Tambah Wishlist'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
