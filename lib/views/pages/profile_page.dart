import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../../models/user.dart';
import '../../models/vault_item.dart';
import '../../routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  final String nama;

  ProfilePage({super.key, required this.nama});

  final CartController cartController = Get.find<CartController>();

  Future<void> _logout() async {
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginData', false);
    Get.offAllNamed(AppRoutes.login);
  }

  void _showLogoutSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: VaultColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Confirm Sign Out',
                style: VaultTypography.sectionTitle,
              ),
              const SizedBox(height: 6),
              Text(
                'Akhiri sesi autentikasi lokal dan kunci brankas VAULTED?',
                style: VaultTypography.cardSub.copyWith(fontSize: 12.5),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: VaultColors.hairline),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _logout();
                      },
                      icon: const Icon(Icons.logout_rounded, size: 16),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VaultColors.neg,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: VaultColors.ink2),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: VaultTypography.cardLabel),
          ),
          Text(
            value,
            style: VaultTypography.mono(fontSize: 12, color: VaultColors.ink2),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: AppBar(
        backgroundColor: VaultColors.background,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Profile',
          style: VaultTypography.sans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: VaultColors.ink,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // 1. Hero Avatar with Gold Ring
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: VaultColors.cardHover,
                  border: Border.all(color: VaultColors.accent, width: 2.5),
                ),
                alignment: Alignment.center,
                child: const ValtoMascot(size: 58, mood: ValtoMood.happy),
              ),
              const SizedBox(height: 14),

              // 2. Name, Handle & Session Pill
              Text(
                nama,
                style: VaultTypography.sans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: VaultColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '@${user1.username}',
                style: VaultTypography.mono(fontSize: 13, color: VaultColors.ink2),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: VaultColors.posBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('SESSION ACTIVE', style: VaultTypography.badgeLabel),
              ),
              const SizedBox(height: 28),

              // 3. Account & Vault Information Card
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ACCOUNT INFORMATION',
                  style: VaultTypography.mono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: VaultColors.ink2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: VaultColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: VaultColors.hairline),
                ),
                child: Column(
                  children: [
                    _infoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Username',
                      value: '@${user1.username}',
                    ),
                    const Divider(height: 1, color: VaultColors.hairline),
                    _infoRow(
                      icon: Icons.verified_outlined,
                      label: 'Session Storage',
                      value: 'SharedPreferences',
                    ),
                    const Divider(height: 1, color: VaultColors.hairline),
                    ValueListenableBuilder(
                      valueListenable: Hive.box<VaultItem>('vault_items').listenable(),
                      builder: (context, box, _) => _infoRow(
                        icon: Icons.lock_outline_rounded,
                        label: 'Warranty Vault',
                        value: '${box.length} perangkat',
                      ),
                    ),
                    const Divider(height: 1, color: VaultColors.hairline),
                    Obx(
                      () => _infoRow(
                        icon: Icons.shield_outlined,
                        label: 'Priority Audit',
                        value: '${cartController.items.length} perangkat',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 4. Logout CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutSheet(context),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
