import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../widgets/recipe_card.dart';

class RecipeListScreen extends StatelessWidget {
  final List<String>? preselectedIngredients;
  const RecipeListScreen({this.preselectedIngredients, super.key});

  static const String _recipesQuery = r'''
    query Recipes($ingredients: [String!]) {
      recipes(ingredientNames: $ingredients) {
        id
        title
        imageUrl
        prepMinutes
        instructions
        ingredients
      }
    }
  ''';

  @override
  Widget build(BuildContext context) {
    final vars = {
      'ingredients': preselectedIngredients ?? [],
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: Query(
        options: QueryOptions(
          document: gql(_recipesQuery),
          variables: vars,
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading && result.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (result.hasException) {
            return Center(
              child: Text('Error: ${result.exception.toString()}'),
            );
          }

          final List recipes = result.data?['recipes'] ?? [];

          if (recipes.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (_, i) => RecipeCard(recipe: recipes[i]),
          );
        },
      ),
    );
  }
}