import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: VaultColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VaultColors.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Container(
                        color: VaultColors.background,
                        padding: const EdgeInsets.all(10),
                        child: Image.network(
                          product.images.isNotEmpty ? product.images[0] : '',
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.image_outlined, color: VaultColors.ink3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: VaultColors.card,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: VaultColors.hairline),
                      ),
                      child: Text(
                        '★ ${product.rating.toStringAsFixed(1)}',
                        style: VaultTypography.mono(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: VaultColors.accentWarm,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: VaultTypography.mono(
                        fontSize: 9,
                        letterSpacing: 0.8,
                        color: VaultColors.ink3,
                      ),
                    ),
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: VaultTypography.cardLabel,
                    ),
                    Text(
                      '\$${product.price}',
                      style: VaultTypography.mono(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: VaultColors.ink,
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
