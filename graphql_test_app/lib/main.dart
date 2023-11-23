/// <----- main.dart ----->
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'graphql_provider/character_list.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _client = ValueNotifier(GraphQLClient(
      link: HttpLink("https://rickandmortyapi.com/graphql"),
    cache: GraphQLCache(),
  ));

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: _client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CharacterList(),
      ),
    );
  }
}
