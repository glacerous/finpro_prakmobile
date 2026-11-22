import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/vault_back_button.dart';
import '../../models/vault_item.dart';

class AddVaultItemPage extends StatefulWidget {
  final int? index;
  final VaultItem? item;

  const AddVaultItemPage({super.key, this.index, this.item});

  @override
  State<AddVaultItemPage> createState() => _AddVaultItemPageState();
}

class _AddVaultItemPageState extends State<AddVaultItemPage> {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();

  bool get _isEditMode => widget.index != null && widget.item != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      titleController.text = widget.item!.title;
      subtitleController.text = widget.item!.subtitle;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  Future<void> _pickWarrantyDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked == null) return;
    final dateStr = '${picked.day}/${picked.month}/${picked.year}';
    setState(() {
      subtitleController.text = 'Garansi s/d $dateStr';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        leading: const VaultBackButton(),
        title: Text(
          _isEditMode ? 'Edit Data Garansi' : 'Tambah Aset Garansi',
          style: VaultTypography.sectionTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nama Perangkat (mis. MacBook Pro)',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: subtitleController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Info Garansi & Harga',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  tooltip: 'Pilih Tanggal Garansi',
                  onPressed: _pickWarrantyDate,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isEmpty) {
                  VaultToast.show(
                    context,
                    icon: Icons.error_outline_rounded,
                    iconColor: VaultColors.neg,
                    message: 'Nama perangkat wajib diisi.',
                  );
                  return;
                }
                final box = Hive.box<VaultItem>('vault_items');
                final newItem = VaultItem(
                  title: title,
                  subtitle: subtitleController.text.trim(),
                );
                if (_isEditMode) {
                  box.putAt(widget.index!, newItem);
                } else {
                  box.add(newItem);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VaultColors.primaryButton,
                foregroundColor: VaultColors.primaryButtonInk,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_isEditMode ? 'Simpan Perubahan' : 'Daftarkan Garansi'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
