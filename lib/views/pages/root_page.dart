import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../models/user.dart';
import 'home_page.dart';
import 'lbs_page.dart';
import 'profile_page.dart';
import 'vault_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  Widget _buildTabItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? VaultColors.cardHover : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 20,
                color: isSelected ? VaultColors.ink : VaultColors.ink2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: VaultTypography.sans(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? VaultColors.ink : VaultColors.ink2,
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
      const VaultPage(),
      const LbsPage(),
      ProfilePage(nama: nama),
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
                  label: 'Vault',
                  icon: Icons.account_balance_wallet_outlined,
                  activeIcon: Icons.account_balance_wallet_rounded,
                ),
                _buildTabItem(
                  index: 1,
                  label: 'Assets',
                  icon: Icons.lock_outline_rounded,
                  activeIcon: Icons.lock_rounded,
                ),
                _buildTabItem(
                  index: 2,
                  label: 'Radar',
                  icon: Icons.radar_outlined,
                  activeIcon: Icons.radar_rounded,
                ),
                _buildTabItem(
                  index: 3,
                  label: 'Profile',
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
