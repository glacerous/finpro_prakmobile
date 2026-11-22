import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/colors.dart';
import 'models/vault_item.dart';
import 'views/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(VaultItemAdapter());
  await Hive.openBox<VaultItem>('vault_items');

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
