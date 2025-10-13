import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/mock_data_service.dart';

class MockLink extends Link {
  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    print('=== MockLink REQUEST START ===');
    print('MockLink: Request type: ${request.runtimeType}');
    print('MockLink: Request operation: ${request.operation}');
    print('MockLink: Request variables: ${request.variables}');
    print('MockLink: Request variables type: ${request.variables.runtimeType}');
    
    try {
      // Log the query document
      if (request.operation.document != null) {
        print('MockLink: Query document: ${request.operation.document}');
      }
      
      // Simulate network delay
      print('MockLink: Simulating network delay...');
      await MockDataService.simulateDelay();
      print('MockLink: Network delay complete');

      // Parse the query to determine what data to return
      final variables = request.variables;
      
      print('MockLink: Processing variables: $variables');
      
      Map<String, dynamic> data = {};
      
      // Simple detection logic based on variables and common patterns
      // If it has 'ingredients' variable, it's a recipes query
      if (variables.containsKey('ingredients')) {
        final ingredients = variables['ingredients'] as List<String>?;
        print('MockLink: Detected RECIPES query with ingredients: $ingredients');
        print('MockLink: Calling MockDataService.getRecipes($ingredients)');
        data = MockDataService.getRecipes(ingredients);
        print('MockLink: Got recipes data: $data');
      } 
      // If no variables or no ingredients, check if it's likely a badges query
      // Badges query typically has no variables
      else if (variables.isEmpty || variables.keys.every((key) => !['ingredients'].contains(key))) {
        print('MockLink: Detected BADGES query (no ingredients variable)');
        print('MockLink: Calling MockDataService.getBadges()');
        data = MockDataService.getBadges();
        print('MockLink: Got badges data: $data');
      } 
      // Default fallback to recipes
      else {
        print('MockLink: Defaulting to RECIPES (fallback)');
        print('MockLink: Calling MockDataService.getRecipes(null)');
        data = MockDataService.getRecipes(null);
        print('MockLink: Got default recipes data: $data');
      }

      print('MockLink: Final response data keys: ${data.keys}');
      print('MockLink: Final response data: $data');

      final response = Response(
        data: data,
        response: const {},
        context: const Context(),
      );
      
      print('MockLink: Created Response object: ${response.data}');
      print('=== MockLink YIELDING RESPONSE ===');
      
      yield response;
      
      print('MockLink: Response yielded successfully');
      
    } catch (e, stackTrace) {
      print('=== MockLink ERROR ===');
      print('MockLink: Exception caught: $e');
      print('MockLink: Exception type: ${e.runtimeType}');
      print('MockLink: StackTrace: $stackTrace');
      
      // Yield error response
      yield Response(
        data: null,
        errors: [GraphQLError(message: 'MockLink error: $e')],
        response: const {},
        context: const Context(),
      );
    }
  }
}

class MockGraphQLClient {
  static GraphQLClient create() {
    return GraphQLClient(
      link: MockLink(),
      cache: GraphQLCache(store: InMemoryStore()),
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.noCache, // Disable caching for mock data
        ),
      ),
    );
  }
}