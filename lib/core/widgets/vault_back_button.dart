import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../constants/colors.dart';

class VaultBackButton extends StatelessWidget {
  const VaultBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded, color: VaultColors.ink),
      onPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Get.offAllNamed(AppRoutes.root);
        }
      },
    );
  }
}
