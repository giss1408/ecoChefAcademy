import 'package:flutter/material.dart';

/// Displays the full details of a single recipe.
class RecipeDetailScreen extends StatelessWidget {
  /// The recipe data comes from the GraphQL query.
  /// Expected keys: title, imageUrl, prepMinutes, ingredients (List), instructions.
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    required this.recipe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Defensive defaults – the backend should always send a list,
    // but we guard against a malformed payload.
    final List<dynamic> ingredients = recipe['ingredients'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'] ?? 'Recipe'),
        actions: [
          // OPTIONAL: a quick‑share button (feel free to remove)
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share),
            onPressed: () {
              // Simple share via the native share sheet (needs `share_plus` package)
              // Share.share('Check out this recipe: ${recipe['title']}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- IMAGE ----------
            if (recipe['imageUrl'] != null)
              Image.network(
                recipe['imageUrl'] as String,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 200),
              ),
            const SizedBox(height: 12),

            // ---------- PREPARATION TIME ----------
            Text(
              // Fixed quoting – outer string uses double quotes.
              "Preparation time: ${recipe['prepMinutes']} min",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Divider(height: 32),

            // ---------- INGREDIENTS ----------
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: ingredients
                  .map<Widget>((i) => Chip(label: Text(i.toString())))
                  .toList(),
            ),
            const Divider(height: 32),

            // ---------- INSTRUCTIONS ----------
            const Text(
              'Instructions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              recipe['instructions'] ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}