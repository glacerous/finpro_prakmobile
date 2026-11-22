import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../../routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  final String nama;

  const ProfilePage({super.key, required this.nama});

  Future<void> _logout() async {
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginData', false);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: VaultColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: VaultColors.hairline),
                ),
                child: Column(
                  children: [
                    const ValtoMascot(size: 80, mood: ValtoMood.happy),
                    const SizedBox(height: 14),
                    Text(nama, style: VaultTypography.sectionTitle.copyWith(fontSize: 20)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: VaultColors.posBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'SESSION ACTIVE',
                        style: VaultTypography.badgeLabel,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Lock & Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: VaultColors.neg,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
