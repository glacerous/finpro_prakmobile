import 'package:flutter/material.dart';
import 'core/constants/colors.dart';
import 'views/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VAULTED',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: VaultColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: VaultColors.accent),
      ),
      home: const LoginPage(),
    );
  }
}
