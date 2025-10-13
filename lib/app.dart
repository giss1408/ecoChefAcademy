import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/mock_client.dart';
import 'ui/screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';   // <-- new import

/*
class EcoChefApp extends StatelessWidget {
  const EcoChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialise GraphQL client once for the whole app
    final HttpLink httpLink = HttpLink(
      // <-- CHANGE THIS TO YOUR BACKEND URL
      'https://api.yourdomain.com/graphql',
    );

    final GraphQLClient client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    );

    return GraphQLProvider(
      client: ValueNotifier(client),
      child: MaterialApp(
        title: 'EcoChef Academy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'OpenSans',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
*/

class EcoChefApp extends StatelessWidget {
  const EcoChefApp({super.key});

  Future<GraphQLClient> _createClient() async {
    print('=== EcoChefApp._createClient START ===');
    
    // Ensure the box is already open before creating HiveStore
    print('EcoChefApp: Opening Hive box for GraphQL cache');
    await Hive.openBox('graphqlCache'); // This is redundant if done in main, but safe if run only once
    print('EcoChefApp: Hive box opened successfully');
    
    // Use mock client for demo purposes (no backend required)
    print('EcoChefApp: Creating MockGraphQLClient');
    final client = MockGraphQLClient.create();
    print('EcoChefApp: MockGraphQLClient created: ${client.runtimeType}');
    print('EcoChefApp: Client link: ${client.link.runtimeType}');
    print('EcoChefApp: Client cache: ${client.cache.runtimeType}');
    
    return client;
    
    // Original code for real backend:
    // final HttpLink httpLink = HttpLink('https://localhost:8000/graphql');
    // return GraphQLClient(
    //   link: httpLink,
    //   cache: GraphQLCache(store: HiveStore()), // Now safe
    // );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GraphQLClient>(
      future: _createClient(),
      builder: (context, snapshot) {
        print('=== EcoChefApp FutureBuilder ===');
        print('EcoChefApp: ConnectionState: ${snapshot.connectionState}');
        print('EcoChefApp: HasData: ${snapshot.hasData}');
        print('EcoChefApp: HasError: ${snapshot.hasError}');
        
        if (snapshot.hasError) {
          print('EcoChefApp: Error creating client: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        }
        
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          print('EcoChefApp: Client ready, creating GraphQLProvider');
          print('EcoChefApp: Client: ${snapshot.data}');
          
          return GraphQLProvider(
            client: ValueNotifier(snapshot.data!),
            child: MaterialApp(
              title: 'EcoChef Academy',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.green,
                fontFamily: 'OpenSans',
              ),
              home: const HomeScreen(),
            ),
          );
        }
        
        print('EcoChefApp: Showing loading indicator');
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
