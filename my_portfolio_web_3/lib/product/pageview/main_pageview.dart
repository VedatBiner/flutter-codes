import 'package:flutter/material.dart';
import '../../core/controller/main_screen_controller.dart';
import '../../product/home/home_screen.dart';
import '../../product/portfolio/portfolio_screen.dart';
import '../about/about_screen.dart';
import '../contact/contact_screen.dart';
import '../services/service_screen.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: MainScreenController.instance.controller,
      children: const [
        HomeScreen(),
        AboutScreen(),
        ServiceScreen(),
        PortfolioScreen(),
        ContactScreen(),
      ],
    );
  }
}
