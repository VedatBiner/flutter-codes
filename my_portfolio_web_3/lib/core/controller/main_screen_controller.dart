import 'package:flutter/material.dart';
import 'package:my_portfolio_web_3/core/constants/duration.dart';

class MainScreenController extends ChangeNotifier {
  static MainScreenController? _instance;
  static MainScreenController get instance {
    _instance ??= MainScreenController._init();
    return _instance!;
  }

  MainScreenController._init();

  int _currentPage = 0;
  PageController controller = PageController(initialPage: 0);
  int get currentPage => _currentPage;

  void changePage(int page) {
    MainScreenController.instance.controller.animateToPage(
      page,
      duration: PageDuration().durationMs300,
      curve: Curves.elasticInOut,
    );
    _currentPage = page;
    notifyListeners();
  }
}
