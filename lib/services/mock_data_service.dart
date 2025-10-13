import 'dart:math';

class MockDataService {
  static final Random _random = Random();

  // Mock recipes data
  static final List<Map<String, dynamic>> _recipes = [
    {
      'id': '1',
      'title': 'Tomato Spinach Scramble',
      'imageUrl': 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400&h=300&fit=crop',
      'prepMinutes': 15,
      'instructions': 'Heat oil in a pan. Add diced tomatoes and cook for 2 minutes. Add spinach and cook until wilted. Beat eggs and pour into the pan. Scramble until cooked. Season with salt and pepper. Serve hot with cheese on top.',
      'ingredients': ['egg', 'tomato', 'spinach', 'cheese', 'olive oil', 'salt', 'pepper'],
      'videoUrl': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      'videoThumbnail': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=225&fit=crop',
      'videoDuration': 180
    },
    {
      'id': '2',
      'title': 'Cheese and Herb Omelette',
      'imageUrl': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=300&fit=crop',
      'prepMinutes': 10,
      'instructions': 'Beat eggs with a pinch of salt. Heat butter in a non-stick pan. Pour eggs and let set for 30 seconds. Add cheese and herbs on one half. Fold omelette and slide onto plate. Garnish with fresh herbs.',
      'ingredients': ['egg', 'cheese', 'butter', 'herbs', 'salt'],
      'videoUrl': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
      'videoThumbnail': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=225&fit=crop',
      'videoDuration': 240
    },
    {
      'id': '3',
      'title': 'Veggie Pasta Primavera',
      'imageUrl': 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=400&h=300&fit=crop',
      'prepMinutes': 25,
      'instructions': 'Cook pasta according to package directions. In a large pan, sauté garlic and onion. Add tomatoes, spinach, and other vegetables. Toss with cooked pasta and cheese. Season with herbs and serve immediately.',
      'ingredients': ['pasta', 'tomato', 'spinach', 'onion', 'garlic', 'cheese', 'olive oil'],
      'videoUrl': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4',
      'videoThumbnail': 'https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?w=400&h=225&fit=crop',
      'videoDuration': 360
    },
    {
      'id': '4',
      'title': 'Stuffed Bell Peppers',
      'imageUrl': 'https://images.unsplash.com/photo-1594902284225-00b72446b954?w=400&h=300&fit=crop',
      'prepMinutes': 40,
      'instructions': 'Cut tops off bell peppers and remove seeds. Mix cooked rice with ground meat, onion, and tomato. Stuff peppers with mixture and top with cheese. Bake at 375°F for 30 minutes until peppers are tender.',
      'ingredients': ['bell pepper', 'rice', 'ground beef', 'onion', 'tomato', 'cheese'],
      'videoUrl': 'https://sample-videos.com/zip/10/mp4/SampleVideo_640x360_1mb.mp4',
      'videoThumbnail': 'https://images.unsplash.com/photo-1574484284002-952d92456975?w=400&h=225&fit=crop',
      'videoDuration': 420
    },
    {
      'id': '5',
      'title': 'Spinach and Feta Quesadilla',
      'imageUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
      'prepMinutes': 12,
      'instructions': 'Place filling of spinach, feta cheese, and tomatoes on one tortilla. Top with another tortilla. Cook in a skillet for 2-3 minutes per side until golden and cheese melts. Cut into wedges and serve.',
      'ingredients': ['tortilla', 'spinach', 'feta cheese', 'tomato'],
      'videoUrl': 'https://sample-videos.com/zip/10/mp4/SampleVideo_640x360_2mb.mp4',
      'videoThumbnail': 'https://images.unsplash.com/photo-1599974579688-8dbdd335c77f?w=400&h=225&fit=crop',
      'videoDuration': 300
    },
    {
      'id': '6',
      'title': 'Mushroom Risotto',
      'imageUrl': 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&h=300&fit=crop',
      'prepMinutes': 35,
      'instructions': 'Sauté mushrooms until golden. In another pan, toast arborio rice with onion. Gradually add warm broth, stirring constantly. Stir in mushrooms and parmesan cheese. Season and serve immediately.',
      'ingredients': ['arborio rice', 'mushrooms', 'onion', 'vegetable broth', 'parmesan cheese', 'white wine'],
      'videoUrl': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      'videoThumbnail': 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=225&fit=crop',
      'videoDuration': 480
    },
    {
      'id': '7',
      'title': 'Caprese Salad',
      'imageUrl': 'https://images.unsplash.com/photo-1608897013039-887f21d8c804?w=400&h=300&fit=crop',
      'prepMinutes': 8,
      'instructions': 'Slice tomatoes and mozzarella. Arrange alternating slices on a plate with fresh basil leaves. Drizzle with olive oil and balsamic vinegar. Season with salt and pepper. Serve fresh.',
      'ingredients': ['tomato', 'mozzarella', 'basil', 'olive oil', 'balsamic vinegar', 'salt', 'pepper'],
      'videoUrl': null,
      'videoThumbnail': null,
      'videoDuration': null
    },
    {
      'id': '8',
      'title': 'Chicken Stir Fry',
      'imageUrl': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=300&fit=crop',
      'prepMinutes': 20,
      'instructions': 'Cut chicken into strips and marinate. Heat oil in wok, stir-fry chicken until cooked. Add vegetables and stir-fry for 3-4 minutes. Add sauce and toss everything together. Serve over rice.',
      'ingredients': ['chicken breast', 'bell pepper', 'broccoli', 'carrot', 'soy sauce', 'garlic', 'ginger', 'rice'],
      'videoUrl': 'https://sample-videos.com/zip/10/mp4/SampleVideo_640x360_5mb.mp4',
      'videoThumbnail': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=225&fit=crop',
      'videoDuration': 450
    },
  ];

  // Mock badges data
  static final List<Map<String, dynamic>> _badges = [
    {
      'id': '1',
      'code': 'WASTE_WARRIOR',
      'title': 'Waste Warrior',
      'description': 'Saved 10 meals from going to waste',
      'level': 'bronze'
    },
    {
      'id': '2',
      'code': 'VEGGIE_LOVER',
      'title': 'Veggie Lover',
      'description': 'Cooked 5 vegetarian recipes',
      'level': 'silver'
    },
    {
      'id': '3',
      'code': 'QUICK_COOK',
      'title': 'Quick Cook',
      'description': 'Mastered 3 recipes under 15 minutes',
      'level': 'gold'
    },
    {
      'id': '4',
      'code': 'ECO_CHEF',
      'title': 'Eco Chef',
      'description': 'Used local ingredients 20 times',
      'level': 'silver'
    },
    {
      'id': '5',
      'code': 'CREATIVE_GENIUS',
      'title': 'Creative Genius',
      'description': 'Created 5 original recipes',
      'level': 'bronze'
    },
    {
      'id': '6',
      'code': 'SUSTAINABILITY_STAR',
      'title': 'Sustainability Star',
      'description': 'Reduced food waste by 50%',
      'level': 'gold'
    },
  ];

  /// Get recipes, optionally filtered by ingredients
  static Map<String, dynamic> getRecipes(List<String>? ingredientNames) {
    print('=== MockDataService.getRecipes START ===');
    print('MockDataService: Input ingredientNames: $ingredientNames');
    print('MockDataService: Input type: ${ingredientNames.runtimeType}');
    print('MockDataService: Total available recipes: ${_recipes.length}');
    
    List<Map<String, dynamic>> filteredRecipes = _recipes;
    
    if (ingredientNames != null && ingredientNames.isNotEmpty) {
      print('MockDataService: Filtering by ingredients: $ingredientNames');
      filteredRecipes = _recipes.where((recipe) {
        final recipeIngredients = List<String>.from(recipe['ingredients']);
        // Check if recipe contains any of the requested ingredients
        final matches = ingredientNames.any((ingredient) => 
          recipeIngredients.any((recipeIngredient) => 
            recipeIngredient.toLowerCase().contains(ingredient.toLowerCase())
          )
        );
        print('MockDataService: Recipe "${recipe['title']}" matches: $matches (ingredients: $recipeIngredients)');
        return matches;
      }).toList();
      
      print('MockDataService: After filtering, found ${filteredRecipes.length} matches');
      
      // If no exact matches, return a random subset for demo purposes
      if (filteredRecipes.isEmpty) {
        print('MockDataService: No matches found, using first 3 recipes as fallback');
        filteredRecipes = _recipes.take(3).toList();
      }
    } else {
      print('MockDataService: No ingredient filter, returning all recipes');
    }
    
    // Add some randomness to make it feel more dynamic
    filteredRecipes.shuffle(_random);
    print('MockDataService: After shuffling, recipe count: ${filteredRecipes.length}');
    
    // Add __typename to each recipe for GraphQL normalization
    final recipesWithTypename = filteredRecipes.map((recipe) {
      final recipeWithType = {
        ...recipe,
        '__typename': 'Recipe',
      };
      print('MockDataService: Recipe with typename: ${recipeWithType['title']} (id: ${recipeWithType['id']})');
      return recipeWithType;
    }).toList();
    
    final result = {
      'recipes': recipesWithTypename,
      '__typename': 'Query', // Add root-level typename for GraphQL normalization
    };
    
    print('MockDataService: Final result keys: ${result.keys}');
    print('MockDataService: Final result recipes count: ${recipesWithTypename.length}');
    print('MockDataService: Final result: $result');
    print('=== MockDataService.getRecipes END ===');
    
    return result;
  }

  /// Get all badges
  static Map<String, dynamic> getBadges() {
    print('=== MockDataService.getBadges START ===');
    
    // Add __typename to each badge for GraphQL normalization
    final badgesWithTypename = _badges.map((badge) {
      return {
        ...badge,
        '__typename': 'Badge',
      };
    }).toList();
    
    final result = {
      'badges': badgesWithTypename,
      '__typename': 'Query', // Add root-level typename for GraphQL normalization
    };
    
    print('MockDataService: Badge result: $result');
    print('=== MockDataService.getBadges END ===');
    
    return result;
  }

  /// Simulate network delay
  static Future<void> simulateDelay() async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));
  }
}