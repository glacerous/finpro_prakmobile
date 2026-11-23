import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/vault_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../modals/manual_asset_modal.dart';

class SearchRadarScreen extends StatefulWidget {
  const SearchRadarScreen({super.key});

  @override
  State<SearchRadarScreen> createState() => _SearchRadarScreenState();
}

class _SearchRadarScreenState extends State<SearchRadarScreen> {
  final VaultController vaultController = Get.find<VaultController>();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Search & Radar',
                        style: VaultTypography.sans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: VaultColors.ink,
                        ),
                      ),
                      const ValtoMascot(size: 36, mood: ValtoMood.detective),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _query = val.trim().toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Cari perangkat, serial number, atau kategori...',
                      hintStyle: VaultTypography.sans(fontSize: 13, color: VaultColors.ink3),
                      prefixIcon: const Icon(Icons.search_rounded, color: VaultColors.ink2),
                      filled: true,
                      fillColor: VaultColors.card,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: VaultColors.hairline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: VaultColors.hairline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Hardware', 'Gadget', 'Peripheral'].map((cat) {
                        final sel = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedCategory = cat);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: sel ? VaultColors.ink : VaultColors.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel ? VaultColors.ink : VaultColors.hairline,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: VaultTypography.sans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: sel ? Colors.white : VaultColors.ink2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final filtered = vaultController.items.asMap().entries.where((entry) {
                  final item = entry.value;
                  final matchCat =
                      _selectedCategory == 'All' || item.category == _selectedCategory;
                  final matchQuery = _query.isEmpty ||
                      item.name.toLowerCase().contains(_query) ||
                      item.serialNumber.toLowerCase().contains(_query);
                  return matchCat && matchQuery;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada perangkat yang cocok.',
                      style: VaultTypography.cardSub,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final index = filtered[i].key;
                    final item = filtered[i].value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: VaultColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: VaultColors.hairline),
                      ),
                      child: ListTile(
                        onTap: () => ManualAssetModal.show(
                          context,
                          editIndex: index,
                          editItem: item,
                        ),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: VaultColors.cardHover,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.radar_rounded, color: VaultColors.accent),
                        ),
                        title: Text(item.name, style: VaultTypography.cardLabel),
                        subtitle: Text(
                          '${item.category} · Exp ${item.warrantyExpiryDate}',
                          style: VaultTypography.cardSub,
                        ),
                        trailing: Text(
                          vaultController.formatAmount(item.currentValuation),
                          style: VaultTypography.mono(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
