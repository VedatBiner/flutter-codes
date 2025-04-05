import 'package:flutter/material.dart';

import '../pages/widget_builder.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AlphabetListView'),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            isScrollable: true,
            tabs: const [Tab(text: 'WidgetBuilder')],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [ExampleWidgetBuilder()],
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
