import 'package:flutter/material.dart';
import 'package:my_portfolio_web_3/product/home/home_screen.dart';
import 'package:my_portfolio_web_3/product/portfolio/portfolio_screen.dart';
import '../about/about_screen.dart';
import '../contact/contact_screen.dart';
import '../services/service_screen.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key, required this.controller});

  final PageController controller;

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.controller,
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
