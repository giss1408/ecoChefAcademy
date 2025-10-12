import 'package:graphql_flutter/graphql_flutter.dart';

class GQL {
  static GraphQLClient client(String uri) {
    final HttpLink link = HttpLink(uri);
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    );
  }
}