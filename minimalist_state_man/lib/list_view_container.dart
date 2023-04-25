import 'package:flutter/material.dart';
import 'package:minimalist_state_man/post.dart';
import 'package:minimalist_state_man/service_locator.dart';
import 'list_view_state.dart';

class ListViewContainer extends StatelessWidget {
  const ListViewContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = getIt.get<ListViewState>();
    return ValueListenableBuilder<List<Post>>(
      valueListenable: state.postsNotifier,
      builder: (context, postsValue, _) {
        return ListView(
          children: postsValue
              .map(
                (post) => ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                  leading: CircleAvatar(
                    child: Text("${post.id}"),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      state.postsNotifier.postRemoveTapped(post);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              )
              .toList(),
        );
      }
    );
  }
}
