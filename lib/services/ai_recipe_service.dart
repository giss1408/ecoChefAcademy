import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AIRecipeService {
  // In production, this would be your actual backend URL
  static const String _baseUrl = 'https://your-backend-api.com';
  static const String _apiKey = 'your-api-key'; // Store securely in production
  
  /// Analyze fridge image and detect ingredients
  static Future<List<String>> analyzeImage(File imageFile) async {
    print('AIRecipeService: Analyzing image: ${imageFile.path}');
    
    try {
      // Convert image to base64 for API request
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // For now, simulate the API call with mock data
      // In production, replace this with actual API call
      return _simulateIngredientDetection();
      
      /*
      // Production code would look like this:
      final response = await http.post(
        Uri.parse('$_baseUrl/api/analyze-fridge'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'image': base64Image,
          'format': 'jpg',
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['ingredients'] ?? []);
      } else {
        throw Exception('Failed to analyze image: ${response.statusCode}');
      }
      */
    } catch (e) {
      print('AIRecipeService: Error analyzing image: $e');
      rethrow;
    }
  }
  
  /// Generate AI-powered recipes from ingredients
  static Future<List<Map<String, dynamic>>> generateRecipes(List<String> ingredients) async {
    print('AIRecipeService: Generating recipes for ingredients: $ingredients');
    
    try {
      // For now, simulate the AI recipe generation
      // In production, replace this with actual AI API call
      return _simulateRecipeGeneration(ingredients);
      
      /*
      // Production code would look like this:
      final response = await http.post(
        Uri.parse('$_baseUrl/api/generate-recipes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'ingredients': ingredients,
          'dietary_preferences': [],
          'max_recipes': 5,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['recipes'] ?? []);
      } else {
        throw Exception('Failed to generate recipes: ${response.statusCode}');
      }
      */
    } catch (e) {
      print('AIRecipeService: Error generating recipes: $e');
      rethrow;
    }
  }
  
  /// Simulate ingredient detection (remove in production)
  static Future<List<String>> _simulateIngredientDetection() async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));
    
    // Return mock detected ingredients
    final mockIngredients = [
      ['tomato', 'lettuce', 'cucumber', 'carrot'],
      ['chicken', 'broccoli', 'rice', 'onion'],
      ['pasta', 'cheese', 'spinach', 'garlic'],
      ['egg', 'bacon', 'bread', 'avocado'],
      ['salmon', 'lemon', 'asparagus', 'potato'],
    ];
    
    // Return a random selection
    final random = DateTime.now().millisecond % mockIngredients.length;
    return mockIngredients[random];
  }
  
  /// Simulate AI recipe generation (remove in production)
  static Future<List<Map<String, dynamic>>> _simulateRecipeGeneration(List<String> ingredients) async {
    // Simulate AI processing time
    await Future.delayed(const Duration(seconds: 3));
    
    // Generate mock AI recipes based on ingredients
    final recipes = <Map<String, dynamic>>[];
    
    if (ingredients.contains('tomato')) {
      recipes.add({
        'id': 'ai_tomato_pasta',
        'name': 'AI Fresh Tomato Pasta',
        'title': 'AI Fresh Tomato Pasta',
        'description': 'AI-Generated: Sauté garlic in olive oil, add fresh tomatoes and cook until soft. Toss with cooked pasta and fresh herbs. A perfect way to use those ripe tomatoes in your fridge!',
        'imageUrl': 'https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?w=400&h=300&fit=crop',
        'prepMinutes': 20,
        'cookTime': '20 min',
        'difficulty': 'Easy',
        'instructions': 'AI-Generated: Sauté garlic in olive oil, add fresh tomatoes and cook until soft. Toss with cooked pasta and fresh herbs. A perfect way to use those ripe tomatoes in your fridge!',
        'ingredients': ingredients.take(4).toList(),
        'aiGenerated': true,
        'confidence': 0.95,
        '__typename': 'Recipe',
      });
    }
    
    if (ingredients.contains('chicken')) {
      recipes.add({
        'id': 'ai_chicken_stir_fry',
        'name': 'AI Smart Chicken Stir-Fry',
        'title': 'AI Smart Chicken Stir-Fry',
        'description': 'AI-Generated: Cut chicken into strips and stir-fry with your available vegetables. Season with soy sauce and garlic. This recipe maximizes the use of ingredients found in your fridge!',
        'imageUrl': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=300&fit=crop',
        'prepMinutes': 15,
        'cookTime': '15 min',
        'difficulty': 'Medium',
        'instructions': 'AI-Generated: Cut chicken into strips and stir-fry with your available vegetables. Season with soy sauce and garlic. This recipe maximizes the use of ingredients found in your fridge!',
        'ingredients': ingredients.take(5).toList(),
        'aiGenerated': true,
        'confidence': 0.88,
        '__typename': 'Recipe',
      });
    }

    if (ingredients.contains('egg')) {
      recipes.add({
        'id': 'ai_breakfast_scramble',
        'name': 'AI Ultimate Breakfast Scramble',
        'title': 'AI Ultimate Breakfast Scramble',
        'description': 'AI-Generated: Perfect breakfast using your available ingredients. Scramble eggs with bacon, serve on toasted bread with fresh avocado. A nutritious start to your day!',
        'imageUrl': 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=300&fit=crop',
        'prepMinutes': 10,
        'cookTime': '10 min',
        'difficulty': 'Easy',
        'instructions': 'AI-Generated: Cook bacon until crispy, scramble eggs in the same pan. Toast bread and serve with sliced avocado. The AI suggests this combination for maximum nutrition and taste!',
        'ingredients': ingredients.take(4).toList(),
        'aiGenerated': true,
        'confidence': 0.92,
        '__typename': 'Recipe',
      });
    }
    
    // Always add a creative fusion recipe
    recipes.add({
      'id': 'ai_fusion_surprise',
      'name': 'AI Fusion Surprise Bowl',
      'title': 'AI Fusion Surprise Bowl',
      'description': 'AI-Generated: Combine your available ingredients in a creative fusion dish. Mix flavors and textures to create something unique with zero food waste. The AI suggests this creative combination based on your fridge contents!',
      'imageUrl': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=300&fit=crop',
      'prepMinutes': 25,
      'cookTime': '25 min',
      'difficulty': 'Hard',
      'instructions': 'AI-Generated: Combine your available ingredients in a creative fusion dish. Mix flavors and textures to create something unique with zero food waste. The AI suggests this creative combination based on your fridge contents!',
      'ingredients': ingredients,
      'aiGenerated': true,
      'confidence': 0.82,
      '__typename': 'Recipe',
    });
    
    return recipes;
  }
}