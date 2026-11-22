import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';

class HomePage extends StatelessWidget {
  final String nama;

  const HomePage({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        title: Text('Halo, $nama!', style: VaultTypography.sectionTitle),
      ),
      body: Center(
        child: Text(
          'VAULTED Home',
          style: VaultTypography.mono(fontSize: 16, color: VaultColors.ink2),
        ),
      ),
    );
  }
}
