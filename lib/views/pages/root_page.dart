import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../models/user.dart';
import '../../routes/app_routes.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'saran_kesan_screen.dart';
import 'warranty_lbs_screen.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  void _showLogoutConfirmation() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Confirm Sign Out', style: VaultTypography.sectionTitle),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to sign out of Vaulted? Your local session will end safely.',
                style: VaultTypography.sans(fontSize: 12.5, color: VaultColors.ink2),
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
                      onPressed: () async {
                        Navigator.pop(ctx);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('loginData', false);
                        Get.offAllNamed(AppRoutes.login);
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

  Widget _buildTabItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    bool isAction = false,
    VoidCallback? onAction,
    Color? customColor,
  }) {
    final isSelected = !isAction && _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (isAction && onAction != null) {
          onAction();
        } else {
          HapticFeedback.selectionClick();
          setState(() => _selectedIndex = index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? VaultColors.cardHover : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 20,
                color: customColor ?? (isSelected ? VaultColors.ink : VaultColors.ink2),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: VaultTypography.sans(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: customColor ?? (isSelected ? VaultColors.ink : VaultColors.ink2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String nama = (Get.arguments as String?) ?? user1.nama;

    final List<Widget> pages = [
      HomePage(nama: nama),
      const WarrantyLbsScreen(),
      ProfilePage(nama: nama),
      const SaranKesanScreen(),
    ];

    return Scaffold(
      backgroundColor: VaultColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: VaultColors.card,
          border: Border(top: BorderSide(color: VaultColors.hairline, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(
                  index: 0,
                  label: 'Home',
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                ),
                _buildTabItem(
                  index: 1,
                  label: 'Radar',
                  icon: Icons.radar_outlined,
                  activeIcon: Icons.radar_rounded,
                ),
                _buildTabItem(
                  index: 2,
                  label: 'Profile',
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                ),
                _buildTabItem(
                  index: 3,
                  label: 'Saran',
                  icon: Icons.rate_review_outlined,
                  activeIcon: Icons.rate_review_rounded,
                ),
                _buildTabItem(
                  index: 4,
                  label: 'Logout',
                  icon: Icons.logout_rounded,
                  activeIcon: Icons.logout_rounded,
                  isAction: true,
                  onAction: _showLogoutConfirmation,
                  customColor: VaultColors.neg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
