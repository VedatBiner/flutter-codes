import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorThemeData with ChangeNotifier{

  final ThemeData _greenTheme = ThemeData(
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.green,
    appBarTheme: const AppBarTheme(
      color: Colors.green,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
    ).copyWith(
      secondary: Colors.green,
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        color: Colors.white,
      ),
      headline3: TextStyle(
        color: Colors.white,
      ),
    ),
  );

  final ThemeData _redTheme = ThemeData(
    primaryColor: Colors.red,
    scaffoldBackgroundColor: Colors.red,
    appBarTheme: const AppBarTheme(
      color: Colors.red,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red,
    ).copyWith(
      secondary: Colors.red,
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        color: Colors.white,
      ),
      headline3: TextStyle(
        color: Colors.white,
      ),
    ),
  );

  ThemeData _selectedThemeData = ThemeData(
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.green,
    appBarTheme: const AppBarTheme(
      color: Colors.green,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
    ).copyWith(
      secondary: Colors.green,
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        color: Colors.white,
      ),
      headline3: TextStyle(
        color: Colors.white,
      ),
    ),
  );

  bool _isGreen = true;
  static late SharedPreferences _sharedPref;

  void switchTheme(bool selected){
    _isGreen = selected;
    // her çalıştığında save etsin.
    saveThemeToSharedPref(selected);
    notifyListeners();
  }

  ThemeData get selectedThemeData => _isGreen ? _greenTheme : _redTheme;

  // getter
  bool get isGreen => _isGreen;

  // obje getirecek metot
  Future<void> createPrefObject() async{
    _sharedPref = await SharedPreferences.getInstance();
  }

  // kayıt metodu
  void saveThemeToSharedPref(bool value){
    _sharedPref.setBool("themeData", value);
  }

  // uygulama ilk açıldığında sharedpref içinde veri çeken metot
  void loadThemeFromSharedPref(){
    _isGreen = _sharedPref.getBool("themeData") ?? true;
  }

}