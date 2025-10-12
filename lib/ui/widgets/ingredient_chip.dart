import 'package:flutter/material.dart';

class IngredientChip extends StatelessWidget {
  final String name;
  const IngredientChip({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(name, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.green.shade100,
    );
  }
}