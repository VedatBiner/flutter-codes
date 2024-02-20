import 'package:flutter/material.dart';

import '../pages/offset.dart';
import '../pages/unicode.dart';
import '../pages/widget_builder.dart';
import '../pages/rtl.dart';
import '../pages/default.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AlphabetListView'),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Default'),
              Tab(text: 'RTL'),
              Tab(text: 'WidgetBuilder'),
              Tab(text: 'Unicode'),
              Tab(text: 'Offset'),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ExampleDefault(),
              ExampleRTL(),
              ExampleWidgetBuilder(),
              ExampleUnicode(),
              ExampleOffset(),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).colorScheme.primary,
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
