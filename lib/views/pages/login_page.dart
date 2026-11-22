import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../models/user.dart';
import 'root_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoginFailed = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loginData = await SharedPreferences.getInstance();
    final adaLogin = loginData.getBool('loginData') ?? false;
    if (adaLogin && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RootPage(nama: user1.nama)),
      );
    }
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username == user1.username && password == user1.password) {
      final loginData = await SharedPreferences.getInstance();
      await loginData.setBool('loginData', true);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RootPage(nama: user1.nama)),
        );
      }
    } else {
      setState(() {
        isLoggedIn = false;
        isLoginFailed = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal: Username atau Password salah'),
          backgroundColor: VaultColors.neg,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required bool isLoginFailed,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: VaultColors.card,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isLoginFailed ? VaultColors.neg : VaultColors.hairline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isLoginFailed ? VaultColors.neg : VaultColors.hairline,
            width: isLoginFailed ? 1.5 : 1,
          ),
        ),
      ),
    );
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
              // Top 25% Glance Only
              const Spacer(),
              Text(
                'VAULTED',
                textAlign: TextAlign.center,
                style: VaultTypography.mono(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                  color: VaultColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Luxury Asset Vault',
                textAlign: TextAlign.center,
                style: VaultTypography.sans(
                  fontSize: 13,
                  color: VaultColors.ink2,
                ),
              ),
              const Spacer(),
              // Bottom 40% Thumb Touch Zone
              if (!isLoggedIn) ...[
                _inputField(
                  controller: _usernameController,
                  hint: 'Username',
                  isLoginFailed: isLoginFailed,
                ),
                const SizedBox(height: 12),
                _inputField(
                  controller: _passwordController,
                  hint: 'Password',
                  isLoginFailed: isLoginFailed,
                  obscure: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VaultColors.primaryButton,
                    foregroundColor: VaultColors.primaryButtonInk,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: VaultColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: VaultColors.hairline),
                  ),
                  child: Column(
                    children: [
                      Text('Halo, ${user1.nama}!', style: VaultTypography.sectionTitle),
                      const SizedBox(height: 6),
                      Text('Username: ${user1.username}', style: VaultTypography.cardSub),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
