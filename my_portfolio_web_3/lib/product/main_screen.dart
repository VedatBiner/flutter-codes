import 'package:flutter/material.dart';
import '../core/controller/main_screen_controller.dart';
import '../core/extension/theme_extension.dart';
import '../design/main_design/main_control_icon_button.dart';
import '../core/constants/enum/enum.dart';
import '../core/extension/screensize_extension.dart';
import '../core/extension/widget_extension.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    MainScreenController.instance.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      drawer: !context.isDesktop ? const MainDrawer() : null,
      body: Stack(
        children: [
          mainScreenDrawerPageView(context),
          Positioned(
            right: GapEnum.L.value,
            top: GapEnum.xxL.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                mainControllerIconButton(Icons.settings, () {}),
                GapEnum.N.heightBox,
                mainControllerIconButton(Icons.wb_sunny, () {
                  ThemeManager.instance.reverseTheme();
                }),
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
            ? const MainDrawer().expanded(1)
            : const SizedBox.shrink(),
        const MainPageView().expanded(3),
      ],
    );
  }
}

