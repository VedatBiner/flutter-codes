import 'package:flutter/material.dart';
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
    Size size = MediaQuery.of(context).size;
    bool isDesktop = size.width >= 1200;
    bool isTablet = size.width < 1200 && size.width >= 500;
    bool isMobile = size.width < 500;
    return Scaffold(
      drawer: !isDesktop ? MainDrawer(controller: controller) : null,
      body: Stack(
        children: [
          Row(
            children: [
              isDesktop
                  ? Expanded(
                      flex: 1,
                      child: MainDrawer(controller: controller),
                    )
                  : const SizedBox.shrink(),
              Expanded(
                flex: 3,
                child: MainPageView(controller: controller),
              ),
            ],
          ),
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
        ],
      ),
    );
  }
}
