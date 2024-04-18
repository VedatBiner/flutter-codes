/// <----- home_constant.dart ----->

part of 'app_const.dart';

class _HomeConstant {
  _HomeConstant();

  final HomeViewPageController pageController = HomeViewPageController(
    PageController(
      initialPage: 0,
      keepPage: true,
    ),
  );

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}
