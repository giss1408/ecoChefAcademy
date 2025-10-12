import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EcoChefLogo extends StatelessWidget {
  const EcoChefLogo({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      width: size,
      height: size,
      semanticsLabel: 'EcoChef Academy logo',
    );
  }
}