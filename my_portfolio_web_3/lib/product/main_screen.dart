import 'package:flutter/material.dart';
import 'package:my_portfolio_web_3/core/extension/screensize_extension.dart';
import 'package:my_portfolio_web_3/core/extension/widget_extension.dart';
import 'package:my_portfolio_web_3/product/drawer/main_drawer.dart';
import 'package:my_portfolio_web_3/product/pageview/main_pageview.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int number = 0;
  late PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: !context.isDesktop ? MainDrawer(controller: controller) : null,
      body: Stack(
        children: [
          mainScreenDrawerPageView(context),
        ],
      ),
    );
  }

  Row mainScreenDrawerPageView(BuildContext context) {
    return Row(
      children: [
        context.isDesktop
            ? MainDrawer(controller: controller).expanded(1)
            : const SizedBox.shrink(),
        MainPageView(controller: controller).expanded(3),
      ],
    );
  }
}

/*
          Positioned(
            top: 24,
            left: 24,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceOut,
                );

                /// Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
              label: const Text("Data"),
            ),
          ),
          Positioned(
            top: 60,
            left: 24,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceOut,
                );

                /// Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
              label: const Text("Data"),
            ),
          ),
          */
