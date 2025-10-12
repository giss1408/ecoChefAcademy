import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  const HeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/hero.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: 240,
    );
  }
}