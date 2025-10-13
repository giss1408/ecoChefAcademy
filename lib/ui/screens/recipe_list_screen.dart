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
        videoUrl
        videoThumbnail
        videoDuration
      }
    }
  ''';

  @override
  Widget build(BuildContext context) {
    final vars = {
      'ingredients': preselectedIngredients ?? [],
    };

    print('=== RecipeListScreen BUILD START ===');
    print('RecipeListScreen: preselectedIngredients = $preselectedIngredients');
    print('RecipeListScreen: variables = $vars');
    print('RecipeListScreen: query = $_recipesQuery');

    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: Query(
        options: QueryOptions(
          document: gql(_recipesQuery),
          variables: vars,
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
        builder: (result, {fetchMore, refetch}) {
          print('=== QUERY BUILDER CALLED ===');
          print('RecipeListScreen: isLoading=${result.isLoading}');
          print('RecipeListScreen: hasException=${result.hasException}');
          print('RecipeListScreen: isConcrete=${result.isConcrete}');
          print('RecipeListScreen: isNotLoading=${result.isNotLoading}');
          print('RecipeListScreen: isOptimistic=${result.isOptimistic}');
          print('RecipeListScreen: data=${result.data}');
          print('RecipeListScreen: source=${result.source}');
          
          if (result.hasException) {
            print('=== EXCEPTION DETAILS ===');
            print('RecipeListScreen: Exception type: ${result.exception.runtimeType}');
            print('RecipeListScreen: Exception: ${result.exception}');
            if (result.exception != null) {
              print('RecipeListScreen: Exception toString: ${result.exception.toString()}');
              // Try to get more detailed error information
              final exception = result.exception!;
              if (exception.graphqlErrors.isNotEmpty) {
                print('RecipeListScreen: GraphQL Errors: ${exception.graphqlErrors}');
              }
              if (exception.linkException != null) {
                print('RecipeListScreen: Link Exception: ${exception.linkException}');
                print('RecipeListScreen: Link Exception type: ${exception.linkException.runtimeType}');
                print('RecipeListScreen: Link Exception toString: ${exception.linkException.toString()}');
              }
            }
          }
          
          if (result.isLoading && result.data == null) {
            print('RecipeListScreen: Showing loading indicator');
            return const Center(child: CircularProgressIndicator());
          }
          
          if (result.hasException) {
            print('RecipeListScreen: Showing error UI');
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error Details:',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${result.exception.toString()}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        print('RecipeListScreen: Retry button pressed');
                        refetch?.call();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          print('=== DATA PROCESSING ===');
          print('RecipeListScreen: result.data type: ${result.data.runtimeType}');
          print('RecipeListScreen: result.data keys: ${result.data?.keys}');
          
          final List recipes = result.data?['recipes'] ?? [];
          print('RecipeListScreen: Found ${recipes.length} recipes');
          print('RecipeListScreen: recipes type: ${recipes.runtimeType}');
          
          if (recipes.isNotEmpty) {
            print('RecipeListScreen: First recipe: ${recipes[0]}');
            print('RecipeListScreen: First recipe type: ${recipes[0].runtimeType}');
            print('RecipeListScreen: First recipe keys: ${recipes[0].keys}');
          }

          if (recipes.isEmpty) {
            print('RecipeListScreen: No recipes found, showing empty state');
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, color: Colors.grey, size: 48),
                  SizedBox(height: 16),
                  Text('No recipes found.'),
                  SizedBox(height: 16),
                  Text('Try adjusting your ingredients or check your connection.'),
                ],
              ),
            );
          }

          print('RecipeListScreen: Building ListView with ${recipes.length} items');
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (_, i) {
              print('RecipeListScreen: Building recipe card ${i}: ${recipes[i]['title']}');
              try {
                return RecipeCard(recipe: recipes[i]);
              } catch (e, stackTrace) {
                print('RecipeListScreen: Error building recipe card $i: $e');
                print('RecipeListScreen: StackTrace: $stackTrace');
                return Card(
                  child: ListTile(
                    title: Text('Error loading recipe $i'),
                    subtitle: Text('$e'),
                    leading: const Icon(Icons.error),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}