import 'package:flutter/material.dart';
import 'package:my_portfolio_web_3/core/extension/theme_extension.dart';
import '../../core/constants/enum/enum.dart';
import '../../core/extension/screensize_extension.dart';
import '../../core/extension/widget_extension.dart';
import '../core/theme/theme_manager.dart';
import '../product/drawer/main_drawer.dart';
import '../product/pageview/main_pageview.dart';

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
      backgroundColor: context.colorScheme.background,
      drawer: !context.isDesktop ? MainDrawer(controller: controller) : null,
      body: Stack(
        children: [
          mainScreenDrawerPageView(context),
          Positioned(
            right: GapEnum.M.value,
            top: GapEnum.xxL.value,
            child: Column(
              children: [
                const Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 48,
                ),
                GapEnum.N.heightBox,
                IconButton(
                  icon: const Icon(
                    Icons.wb_sunny,
                    size: 48,
                  ),
                  color: Colors.black,
                  onPressed: () {
                    ThemeManager.instance.reverseTheme();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row mainScreenDrawerPageView(BuildContext context) {
    return Row(
      children: [
        context.isDesktop
            ? MainDrawer(controller: controller).expanded(1)

            /// MainDrawer(controller: controller).expanded(1)
            : const SizedBox.shrink(),
        MainPageView(controller: controller).expanded(3),

        /// MainPageView(controller: controller).expanded(3),
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