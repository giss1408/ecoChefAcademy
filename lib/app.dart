import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/client.dart';
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
    // Ensure the box is already open before creating HiveStore
    await Hive.openBox('graphqlCache'); // This is redundant if done in main, but safe if run only once
    final HttpLink httpLink = HttpLink('https://localhost:8000/graphql');
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()), // Now safe
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GraphQLClient>(
      future: _createClient(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
