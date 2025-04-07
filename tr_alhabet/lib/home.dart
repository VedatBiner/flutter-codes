import 'package:flutter/material.dart';

import '../pages/widget_builder.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(title: const Text('AlphabetListView')),
        body: const SafeArea(child: ExampleWidgetBuilder()),
      ),
    );
  }
}
