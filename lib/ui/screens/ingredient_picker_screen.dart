import 'package:flutter/material.dart';
import '../../services/ai_recipe_service.dart';
import 'recipe_detail_screen.dart';

/// Screen for manually selecting ingredients from a comprehensive list
class IngredientPickerScreen extends StatefulWidget {
  const IngredientPickerScreen({super.key});

  @override
  State<IngredientPickerScreen> createState() => _IngredientPickerScreenState();
}

class _IngredientPickerScreenState extends State<IngredientPickerScreen> {
  final Set<String> _selectedIngredients = {};
  bool _isGeneratingRecipes = false;
  List<Map<String, dynamic>> _suggestedRecipes = [];
  String? _generationError;

  // Comprehensive ingredient list organized by category
  static const Map<String, List<String>> _ingredientCategories = {
    'Proteins': [
      'chicken',
      'beef',
      'pork',
      'salmon',
      'tuna',
      'shrimp',
      'egg',
      'tofu',
      'beans',
      'lentils',
      'chickpeas',
      'turkey',
      'lamb',
      'cod',
      'bacon',
    ],
    'Vegetables': [
      'tomato',
      'onion',
      'garlic',
      'carrot',
      'broccoli',
      'spinach',
      'lettuce',
      'cucumber',
      'bell pepper',
      'mushroom',
      'zucchini',
      'asparagus',
      'potato',
      'sweet potato',
      'corn',
      'peas',
      'cabbage',
      'cauliflower',
      'eggplant',
      'celery',
    ],
    'Fruits': [
      'apple',
      'banana',
      'orange',
      'lemon',
      'lime',
      'avocado',
      'strawberry',
      'blueberry',
      'grape',
      'pineapple',
      'mango',
      'kiwi',
      'peach',
      'pear',
      'cherry',
    ],
    'Grains & Starches': [
      'rice',
      'pasta',
      'bread',
      'quinoa',
      'oats',
      'barley',
      'noodles',
      'couscous',
      'bulgur',
      'flour',
      'cereal',
    ],
    'Dairy': [
      'milk',
      'cheese',
      'yogurt',
      'butter',
      'cream',
      'sour cream',
      'mozzarella',
      'parmesan',
      'cheddar',
      'feta',
    ],
    'Herbs & Spices': [
      'basil',
      'oregano',
      'thyme',
      'rosemary',
      'parsley',
      'cilantro',
      'mint',
      'ginger',
      'turmeric',
      'paprika',
      'cumin',
      'black pepper',
      'salt',
      'cinnamon',
    ],
    'Pantry Staples': [
      'olive oil',
      'coconut oil',
      'soy sauce',
      'vinegar',
      'honey',
      'sugar',
      'vanilla',
      'baking powder',
      'nuts',
      'seeds',
    ],
  };

  Future<void> _generateRecipes() async {
    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one ingredient'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isGeneratingRecipes = true;
      _suggestedRecipes = [];
      _generationError = null;
    });

    try {
      final recipes = await AIRecipeService.generateRecipes(_selectedIngredients.toList());
      
      setState(() {
        _suggestedRecipes = recipes.where((recipe) => recipe != null && recipe is Map<String, dynamic>).toList();
        _isGeneratingRecipes = false;
      });
    } catch (e) {
      setState(() {
        _generationError = 'Recipe generation failed: $e';
        _isGeneratingRecipes = false;
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedIngredients.clear();
      _suggestedRecipes.clear();
      _generationError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Your Ingredients'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedIngredients.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear Selection',
              onPressed: _clearSelection,
            ),
        ],
      ),
      body: Column(
        children: [
          // Selected ingredients display
          if (_selectedIngredients.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_basket, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Selected Ingredients (${_selectedIngredients.length})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _selectedIngredients.map((ingredient) => Chip(
                      label: Text(ingredient),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _selectedIngredients.remove(ingredient);
                        });
                      },
                      backgroundColor: Colors.green.shade100,
                      deleteIconColor: Colors.green.shade700,
                    )).toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isGeneratingRecipes ? null : _generateRecipes,
                      icon: _isGeneratingRecipes 
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.auto_awesome),
                      label: Text(_isGeneratingRecipes ? 'Generating Recipes...' : 'Generate AI Recipes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Generated recipes display
          if (_suggestedRecipes.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.restaurant_menu, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'AI Recipe Suggestions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = _suggestedRecipes[index];
                  
                  if (recipe == null || recipe is! Map<String, dynamic>) {
                    return const SizedBox.shrink();
                  }
                  
                  return Container(
                    width: 300,
                    margin: const EdgeInsets.only(right: 12),
                    child: Card(
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe['name']?.toString() ?? recipe['title']?.toString() ?? 'AI Recipe',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  recipe['description']?.toString() ?? recipe['instructions']?.toString() ?? 'AI-generated recipe',
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    recipe['cookTime']?.toString() ?? 'Unknown',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(Icons.signal_cellular_alt, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    recipe['difficulty']?.toString() ?? 'Unknown',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Error display
          if (_generationError != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    _generationError!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],

          // Ingredient categories
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _ingredientCategories.keys.length,
              itemBuilder: (context, index) {
                final category = _ingredientCategories.keys.elementAt(index);
                final ingredients = _ingredientCategories[category]!;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Icon(
                        _getCategoryIcon(category),
                        color: Colors.green.shade700,
                      ),
                    ),
                    title: Text(
                      category,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${ingredients.length} ingredients',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ingredients.map((ingredient) {
                            final isSelected = _selectedIngredients.contains(ingredient);
                            return FilterChip(
                              label: Text(ingredient),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedIngredients.add(ingredient);
                                  } else {
                                    _selectedIngredients.remove(ingredient);
                                  }
                                });
                              },
                              selectedColor: Colors.green.shade200,
                              checkmarkColor: Colors.green.shade700,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Proteins':
        return Icons.set_meal;
      case 'Vegetables':
        return Icons.eco;
      case 'Fruits':
        return Icons.apple;
      case 'Grains & Starches':
        return Icons.grain;
      case 'Dairy':
        return Icons.local_drink;
      case 'Herbs & Spices':
        return Icons.local_florist;
      case 'Pantry Staples':
        return Icons.kitchen;
      default:
        return Icons.category;
    }
  }
}