import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        title: Text(
          _isEditMode ? 'Edit Aset' : 'Tambah Aset',
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
                labelText: 'Nama Aset',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: subtitleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Catatan / Estimasi Nilai',
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final box = Hive.box<VaultItem>('vault_items');
                final newItem = VaultItem(
                  title: titleController.text.trim(),
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
              child: Text(_isEditMode ? 'Simpan' : 'Tambah'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
