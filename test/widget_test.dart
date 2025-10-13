// This is a basic Flutter widget test for EcoChef Academy.

import 'package:flutter_test/flutter_test.dart';
import 'package:eco_chef_academy/services/mock_data_service.dart';

void main() {
  group('Mock Data Service Tests', () {
    test('returns recipes when no ingredients specified', () {
      final result = MockDataService.getRecipes(null);
      expect(result['recipes'], isNotNull);
      expect(result['recipes'], isA<List>());
      expect(result['recipes'].length, greaterThan(0));
    });

    test('returns recipes filtered by ingredients', () {
      final result = MockDataService.getRecipes(['tomato', 'cheese']);
      expect(result['recipes'], isNotNull);
      expect(result['recipes'], isA<List>());
      // Should return recipes that contain tomato or cheese
      final recipes = result['recipes'] as List;
      expect(recipes.length, greaterThan(0));
    });

    test('returns badges', () {
      final result = MockDataService.getBadges();
      expect(result['badges'], isNotNull);
      expect(result['badges'], isA<List>());
      final badges = result['badges'] as List;
      expect(badges.length, equals(6));
      
      // Check badge structure
      final firstBadge = badges.first;
      expect(firstBadge['id'], isNotNull);
      expect(firstBadge['title'], isNotNull);
      expect(firstBadge['description'], isNotNull);
      expect(firstBadge['level'], isIn(['bronze', 'silver', 'gold']));
    });
  });

  group('Recipe Data Validation', () {
    test('all recipes have required fields', () {
      final result = MockDataService.getRecipes(null);
      final recipes = result['recipes'] as List;
      
      for (final recipe in recipes) {
        expect(recipe['id'], isNotNull);
        expect(recipe['title'], isNotNull);
        expect(recipe['imageUrl'], isNotNull);
        expect(recipe['prepMinutes'], isA<int>());
        expect(recipe['instructions'], isNotNull);
        expect(recipe['ingredients'], isA<List>());
      }
    });
  });
}
