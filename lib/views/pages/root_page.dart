import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
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
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: VaultColors.hairline)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: VaultColors.ink,
          unselectedItemColor: VaultColors.ink3,
          backgroundColor: VaultColors.card,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            HapticFeedback.selectionClick();
            setState(() => _selectedIndex = index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Market'),
            BottomNavigationBarItem(icon: Icon(Icons.lock_outline), label: 'Brankas'),
            BottomNavigationBarItem(icon: Icon(Icons.radar_outlined), label: 'Radar'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
