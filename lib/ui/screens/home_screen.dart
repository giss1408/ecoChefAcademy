import 'package:flutter/material.dart';
import '../widgets/logo.dart';
import '../widgets/hero_image.dart';
import 'scan_screen.dart';
import 'recipe_list_screen.dart';
import 'badge_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            EcoChefLogo(size: 32),
            SizedBox(width: 8),
            Text('EcoChef Academy'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'My Badges',
            icon: const Icon(Icons.emoji_events),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BadgeScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        children: const [
          HeroImage(),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Turn what you already have into tasty, waste‑free meals.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          // Primary actions
          _ActionButtons(),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Scan My Fridge'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScanScreen()),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.menu_book),
            label: const Text('Browse Recipes'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecipeListScreen()),
            ),
          ),
        ],
      ),
    );
  }
}