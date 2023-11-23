/// <----- character_detail.dart ----->
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/character_detail_model.dart';
import '../queries/character_query.dart' as queries;

class CharacterDetailView extends StatelessWidget {
  const CharacterDetailView({Key? key, required this.selectedCharacterId})
      : super(key: key);
  final String selectedCharacterId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Detail"),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(queries.readCharacterById),
          variables: {"characterId": selectedCharacterId},
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          } else if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          CharacterDetailModel? characterDetail =
              (result.data?["charactersByIds"] as List?)
                  ?.map((character) => CharacterDetailModel.fromJson(character))
                  .toList()[0];

          return Column(
            children: [
              SizedBox(
                height: 240,
                width: double.infinity,
                child: Image.network(
                  characterDetail?.image ?? "",
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          characterDetail?.name ?? "",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          characterDetail?.species ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.purple),
                        ),
                      ],
                    ),
                    Text(
                      characterDetail?.gender ?? "",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Divider(),
                    Text(
                      "Episodes",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Divider()
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: characterDetail?.episode?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final currentItem = characterDetail?.episode?[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(currentItem?.id ?? ""),
                      ),
                      title: Text(currentItem?.name ?? ""),
                      subtitle: Text(currentItem?.episode ?? ""),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
