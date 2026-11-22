import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../../models/user.dart';
import '../../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoginFailed = false;
  bool _obscurePassword = true;

  late AnimationController _levitateController;
  late Animation<double> _levitateAnim;

  @override
  void initState() {
    super.initState();
    _levitateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _levitateAnim = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _levitateController, curve: Curves.easeInOutSine),
    );
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loginData = await SharedPreferences.getInstance();
    final adaLogin = loginData.getBool('loginData') ?? false;
    if (adaLogin) {
      Get.offAllNamed(AppRoutes.root, arguments: user1.nama);
    }
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username == user1.username && password == user1.password) {
      HapticFeedback.lightImpact();
      final loginData = await SharedPreferences.getInstance();
      await loginData.setBool('loginData', true);
      Get.offAllNamed(AppRoutes.root, arguments: user1.nama);
    } else {
      HapticFeedback.heavyImpact();
      setState(() => isLoginFailed = true);
      VaultToast.show(
        context,
        icon: Icons.error_outline_rounded,
        iconColor: VaultColors.neg,
        message: 'Username atau Password salah.',
      );
    }
  }

  @override
  void dispose() {
    _levitateController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: VaultTypography.sans(fontSize: 14, color: VaultColors.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: VaultTypography.sans(fontSize: 13, color: VaultColors.ink3),
        prefixIcon: Icon(icon, size: 18, color: VaultColors.ink2),
        suffixIcon: suffix,
        filled: true,
        fillColor: VaultColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isLoginFailed ? VaultColors.neg : VaultColors.hairline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              VaultColors.sunsetTop,
              VaultColors.sunsetMid,
              VaultColors.sunsetBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Top 25% Glance Only: Wordmark & Mascot
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: VaultColors.badgeBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'PRIVATE ASSET VAULT',
                      style: VaultTypography.mono(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: VaultColors.accentWarm,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'VAULTED',
                  textAlign: TextAlign.center,
                  style: VaultTypography.mono(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 6,
                    color: VaultColors.ink,
                  ),
                ),
                const Spacer(),
                // Levitating Valto Mascot
                AnimatedBuilder(
                  animation: _levitateAnim,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(0, _levitateAnim.value),
                    child: child,
                  ),
                  child: const Center(
                    child: ValtoMascot(size: 130, mood: ValtoMood.vigilant),
                  ),
                ),
                const Spacer(),
                // Bottom 40% Thumb Touch Zone
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: VaultColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: VaultColors.hairline),
                    boxShadow: [
                      BoxShadow(
                        color: VaultColors.ink.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _inputField(
                        controller: _usernameController,
                        hint: 'Username',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 12),
                      _inputField(
                        controller: _passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePassword,
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                            color: VaultColors.ink2,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VaultColors.primaryButton,
                          foregroundColor: VaultColors.primaryButtonInk,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Unlock Vault',
                          style: VaultTypography.sans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
