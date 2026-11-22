import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../models/product.dart';
import '../../services/api_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  final String nama;

  const HomePage({super.key, required this.nama});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final productData = await ApiService.getProducts();
      if (!mounted) return;
      setState(() {
        products = productData;
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
        title: Text('Halo, ${widget.nama}!', style: VaultTypography.sectionTitle),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: VaultColors.accent))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: VaultColors.card,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: VaultColors.hairline),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(productId: product.id),
                        ),
                      );
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.images.isNotEmpty ? product.images[0] : '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(Icons.image),
                      ),
                    ),
                    title: Text(product.title, style: VaultTypography.cardLabel),
                    subtitle: Text(
                      '\$${product.price}',
                      style: VaultTypography.mono(fontSize: 12, color: VaultColors.ink2),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: VaultColors.ink3),
                  ),
                );
              },
            ),
    );
  }
}
