import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'vault_page.dart';

class RootPage extends StatefulWidget {
  final String nama;

  const RootPage({super.key, required this.nama});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(nama: widget.nama),
      const VaultPage(),
      ProfilePage(nama: widget.nama),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: VaultColors.ink,
        unselectedItemColor: VaultColors.ink3,
        backgroundColor: VaultColors.card,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.lock_outline), label: 'Brankas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
