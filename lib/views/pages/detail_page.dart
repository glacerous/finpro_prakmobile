import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../models/product.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key});

  final Product product = Get.arguments as Product;
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        title: Text('Detail', style: VaultTypography.sectionTitle),
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
                        '\$${product.price}',
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
                  Text('Stock: ${product.stock}', style: VaultTypography.cardSub),
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
                    Text('Reviews', style: VaultTypography.sectionTitle),
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
          // Bottom Thumb Zone CTA
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  cartController.addToCart(product);
                  Get.snackbar(
                    'Keranjang',
                    '${product.title} ditambahkan',
                    snackPosition: SnackPosition.BOTTOM,
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
                child: const Text('Tambahkan ke Keranjang'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
