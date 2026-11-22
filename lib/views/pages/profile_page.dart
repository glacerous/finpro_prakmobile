import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  final String nama;

  const ProfilePage({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        title: Text('Profil', style: VaultTypography.sectionTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.account_circle, size: 88, color: VaultColors.accent),
            const SizedBox(height: 16),
            Text(nama, style: VaultTypography.sectionTitle),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: VaultColors.neg,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
