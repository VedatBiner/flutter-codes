/// <----- home_constant.dart ----->
part of "../constant/app_const.dart";

class _HomeConstant {
  _HomeConstant();

  final LanguageModel themeText = LanguageModel(
    tr: "Tema Modu",
    en: "Theme Mode",
  );
  final LanguageModel welcome = LanguageModel(
    tr: "Hoşgeldiniz",
    en: "Welcome",
  );
  final HomeViewPageController pageController = HomeViewPageController(
    PageController(
      initialPage: 0,
      keepPage: true,
    ),
  );
  final GlobalKey scaffoldKey = GlobalKey();
}
