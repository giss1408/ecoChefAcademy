import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AIRecipeService {
  // In production, this would be your actual backend URL
  static const String _baseUrl = 'https://your-backend-api.com';
  static const String _apiKey = 'your-api-key'; // Store securely in production
  
  // SPEED OPTIMIZED: Pre-computed recipe templates for instant generation
  // This eliminates the need for dynamic recipe construction, reducing CPU usage
  static const _recipeTemplates = {
    'tomato': {
      'id': 'ai_tomato_pasta',
      'name': 'AI Fresh Tomato Pasta',
      'title': 'AI Fresh Tomato Pasta',
      'description': 'AI-Generated: Sauté garlic in olive oil, add fresh tomatoes and cook until soft. Toss with cooked pasta and fresh herbs. A perfect way to use those ripe tomatoes in your fridge!',
      'imageUrl': 'https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?w=400&h=300&fit=crop',
      'prepMinutes': 20,
      'cookTime': '20 min',
      'difficulty': 'Easy',
      'instructions': 'AI-Generated: Sauté garlic in olive oil, add fresh tomatoes and cook until soft. Toss with cooked pasta and fresh herbs. A perfect way to use those ripe tomatoes in your fridge!',
      'aiGenerated': true,
      'confidence': 0.95,
      '__typename': 'Recipe',
    },
    'chicken': {
      'id': 'ai_chicken_stir_fry',
      'name': 'AI Smart Chicken Stir-Fry',
      'title': 'AI Smart Chicken Stir-Fry',
      'description': 'AI-Generated: Cut chicken into strips and stir-fry with your available vegetables. Season with soy sauce and garlic. This recipe maximizes the use of ingredients found in your fridge!',
      'imageUrl': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=300&fit=crop',
      'prepMinutes': 15,
      'cookTime': '15 min',
      'difficulty': 'Medium',
      'instructions': 'AI-Generated: Cut chicken into strips and stir-fry with your available vegetables. Season with soy sauce and garlic. This recipe maximizes the use of ingredients found in your fridge!',
      'aiGenerated': true,
      'confidence': 0.88,
      '__typename': 'Recipe',
    },
    'egg': {
      'id': 'ai_breakfast_scramble',
      'name': 'AI Ultimate Breakfast Scramble',
      'title': 'AI Ultimate Breakfast Scramble',
      'description': 'AI-Generated: Perfect breakfast using your available ingredients. Scramble eggs with bacon, serve on toasted bread with fresh avocado. A nutritious start to your day!',
      'imageUrl': 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=300&fit=crop',
      'prepMinutes': 10,
      'cookTime': '10 min',
      'difficulty': 'Easy',
      'instructions': 'AI-Generated: Cook bacon until crispy, scramble eggs in the same pan. Toast bread and serve with sliced avocado. The AI suggests this combination for maximum nutrition and taste!',
      'aiGenerated': true,
      'confidence': 0.92,
      '__typename': 'Recipe',
    },
  };
  
  /// Analyze fridge image and detect ingredients
  static Future<List<String>> analyzeImage(File imageFile) async {
    print('AIRecipeService: Analyzing image: ${imageFile.path}');
    
    try {
      // SPEED OPTIMIZED: Skip base64 encoding in mock mode for faster processing
      // In production, this will be needed for API calls
      // final bytes = await imageFile.readAsBytes();
      // final base64Image = base64Encode(bytes);
      
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
    // SPEED OPTIMIZED: Reduce delay to 200ms for ultra-fast response
    await Future.delayed(const Duration(milliseconds: 200));
    
    // SPEED OPTIMIZED: Pre-computed ingredient combinations for faster access
    const mockIngredients = [
      ['tomato', 'lettuce', 'cucumber', 'carrot'],
      ['chicken', 'broccoli', 'rice', 'onion'],
      ['pasta', 'cheese', 'spinach', 'garlic'],
      ['egg', 'bacon', 'bread', 'avocado'],
      ['salmon', 'lemon', 'asparagus', 'potato'],
    ];
    
    // SPEED OPTIMIZED: Use bitwise operation for faster random selection
    final random = DateTime.now().microsecondsSinceEpoch & (mockIngredients.length - 1);
    return mockIngredients[random];
  }
  
  /// Simulate AI recipe generation (remove in production)
  static Future<List<Map<String, dynamic>>> _simulateRecipeGeneration(List<String> ingredients) async {
    // SPEED OPTIMIZED: Reduce AI processing time to 300ms for near-instant response
    await Future.delayed(const Duration(milliseconds: 300));
    
    // SPEED OPTIMIZED: Use dynamic list to avoid null entries and casting issues
    final recipes = <Map<String, dynamic>>[];
    
    // SPEED OPTIMIZED: Use pre-computed templates with direct assignment
    for (final ingredient in ingredients) {
      final template = _recipeTemplates[ingredient];
      if (template != null) {
        // Direct template usage with ingredient injection for maximum speed
        recipes.add({
          ...template,
          'ingredients': ingredient == 'chicken' 
              ? ingredients.take(5).toList() 
              : ingredients.take(4).toList(),
        });
      }
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