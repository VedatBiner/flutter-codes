import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.slivers,
    this.reverse = false,
  });

  final String title;
  final List<Widget> slivers;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return DefaultStickyHeaderController(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: CustomScrollView(
          slivers: slivers,
          reverse: reverse,
        ),
        floatingActionButton: const _FloatingActionButton(),
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: () {
        final double offset =
            DefaultStickyHeaderController.of(context)!.stickyHeaderScrollOffset;
        PrimaryScrollController.of(context).animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      },
      child: const Icon(Icons.adjust),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    this.index,
    this.title,
    this.color = Colors.lightBlue,
  });

  final String? title;
  final int? index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('hit $index');
      },
      child: Container(
        height: 60,
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          title ?? 'Header #$index',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}