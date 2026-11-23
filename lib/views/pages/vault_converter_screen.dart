import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/vault_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/vault_back_button.dart';

class VaultConverterScreen extends StatefulWidget {
  const VaultConverterScreen({super.key});

  @override
  State<VaultConverterScreen> createState() => _VaultConverterScreenState();
}

class _VaultConverterScreenState extends State<VaultConverterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final VaultController vaultController = Get.find<VaultController>();

  final TextEditingController _amountController = TextEditingController(text: '100');
  String _sourceCurrency = 'USD';

  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);
  String _sourceZone = 'WIB';

  final Map<String, int> _utcOffsets = {
    'WIB': 7,
    'WITA': 8,
    'WIT': 9,
    'London': 0,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final now = DateTime.now();
    _selectedTime = TimeOfDay(hour: now.hour, minute: now.minute);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  double _convertTo(double inputAmount, String from, String to) {
    final rates = vaultController.exchangeRates;
    final fromRate = rates[from] ?? 1.0;
    final toRate = rates[to] ?? 1.0;
    return (inputAmount / fromRate) * toRate;
  }

  String _formatZoneTime(String targetZone) {
    final srcOffset = _utcOffsets[_sourceZone] ?? 7;
    final dstOffset = _utcOffsets[targetZone] ?? 7;
    final totalMinutes =
        (_selectedTime.hour * 60 + _selectedTime.minute) + ((dstOffset - srcOffset) * 60);
    final wrapped = ((totalMinutes % 1440) + 1440) % 1440;
    final h = (wrapped ~/ 60).toString().padLeft(2, '0');
    final m = (wrapped % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final inputAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        leading: const VaultBackButton(),
        title: Text('Currency & Timezone', style: VaultTypography.sectionTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: VaultColors.ink,
          unselectedLabelColor: VaultColors.ink2,
          indicatorColor: VaultColors.accent,
          tabs: const [
            Tab(text: 'Currency'),
            Tab(text: 'Timezone'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Currency Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: VaultColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: VaultColors.hairline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SOURCE AMOUNT',
                          style: VaultTypography.mono(fontSize: 10, color: VaultColors.ink2)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '100',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: ['USD', 'IDR', 'EUR', 'JPY'].map((c) {
                          final sel = _sourceCurrency == c;
                          return ChoiceChip(
                            label: Text(c),
                            selected: sel,
                            selectedColor: VaultColors.ink,
                            labelStyle: TextStyle(
                              color: sel ? Colors.white : VaultColors.ink,
                            ),
                            onSelected: (_) => setState(() => _sourceCurrency = c),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  vaultController.exchangeRates.length;
                  return Column(
                    children: ['USD', 'IDR', 'EUR', 'JPY'].map((c) {
                      final val = _convertTo(inputAmount, _sourceCurrency, c);
                      final formatted = (c == 'IDR' || c == 'JPY')
                          ? NumberFormat('#,##0', 'en_US').format(val)
                          : NumberFormat('#,##0.00', 'en_US').format(val);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: VaultColors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: VaultColors.hairline),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(c, style: VaultTypography.cardLabel),
                            Text(
                              formatted,
                              style: VaultTypography.mono(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),

          // Timezone Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: VaultColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: VaultColors.hairline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SOURCE TIME ($_sourceZone)',
                          style: VaultTypography.mono(fontSize: 10, color: VaultColors.ink2)),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (picked != null) {
                            setState(() => _selectedTime = picked);
                          }
                        },
                        icon: const Icon(Icons.access_time_rounded),
                        label: Text(
                          '${_selectedTime.hour.toString().padLeft(2, '0')}:'
                          '${_selectedTime.minute.toString().padLeft(2, '0')}',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VaultColors.primaryButton,
                          foregroundColor: VaultColors.primaryButtonInk,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _utcOffsets.keys.map((z) {
                          final sel = _sourceZone == z;
                          return ChoiceChip(
                            label: Text(z),
                            selected: sel,
                            selectedColor: VaultColors.ink,
                            labelStyle: TextStyle(
                              color: sel ? Colors.white : VaultColors.ink,
                            ),
                            onSelected: (_) => setState(() => _sourceZone = z),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ..._utcOffsets.keys.map((z) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: VaultColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: VaultColors.hairline),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(z, style: VaultTypography.cardLabel),
                        Text(
                          _formatZoneTime(z),
                          style: VaultTypography.mono(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: VaultColors.accent,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
