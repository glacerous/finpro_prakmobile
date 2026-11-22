import 'package:flutter/material.dart';

enum ValtoMood {
  vigilant,
  playful,
  sleeping,
  happy,
  detective,
  peeking,
}

/// Valto — The Signature Black Cat Mascot of VAULTED.
class ValtoMascot extends StatelessWidget {
  final double size;
  final ValtoMood mood;

  const ValtoMascot({
    super.key,
    this.size = 56,
    this.mood = ValtoMood.vigilant,
  });

  String get _assetPath {
    switch (mood) {
      case ValtoMood.sleeping:
        return 'assets/images/valto_sleeping.png';
      case ValtoMood.playful:
        return 'assets/images/valto_waving.png';
      case ValtoMood.happy:
        return 'assets/images/valto_happy.png';
      case ValtoMood.detective:
        return 'assets/images/valto_detective.png';
      case ValtoMood.peeking:
        return 'assets/images/valto_peeking.png';
      case ValtoMood.vigilant:
        return 'assets/images/valto_vigilant.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none,
    );
  }
}
