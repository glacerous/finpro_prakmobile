import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../models/product.dart';
import '../../services/api_service.dart';

class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Product? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSingleProduct();
  }

  Future<void> fetchSingleProduct() async {
    try {
      final data = await ApiService.getSingleProduct(widget.productId);
      if (!mounted) return;
      setState(() {
        product = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        title: Text('Detail Produk', style: VaultTypography.sectionTitle),
      ),
      body: isLoading || product == null
          ? const Center(child: CircularProgressIndicator(color: VaultColors.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product!.images.isNotEmpty)
                    Center(
                      child: Image.network(
                        product!.images[0],
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(product!.title, style: VaultTypography.sectionTitle.copyWith(fontSize: 22)),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product!.price}',
                    style: VaultTypography.mono(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: VaultColors.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Kategori: ${product!.category}', style: VaultTypography.cardSub),
                  const SizedBox(height: 16),
                  Text('Deskripsi', style: VaultTypography.cardLabel),
                  const SizedBox(height: 6),
                  Text(product!.description, style: VaultTypography.cardDescription),
                ],
              ),
            ),
    );
  }
}
