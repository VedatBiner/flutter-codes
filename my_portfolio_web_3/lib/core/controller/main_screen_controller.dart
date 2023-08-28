import 'package:flutter/material.dart';

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
    _currentPage = page;
    notifyListeners();
  }
}
