import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData green = ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.green.shade50);

ThemeData red = ThemeData(
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: Colors.red.shade50);

class ThemeColorData with ChangeNotifier{

  static late SharedPreferences _sharedPrefObject;
  bool _isGreen = true;

  //getter
  bool get isGreen => _isGreen;

  //getter
  ThemeData get themeColor {
    return _isGreen ? green : red;
  }

  void toggleTheme(){
    _isGreen = !_isGreen;
    saveThemeToSharedPref(_isGreen);
    notifyListeners();
  }

  Future<void> createSharedPrefObject() async {
    _sharedPrefObject = await SharedPreferences.getInstance();
  }

  // yazma metodu
  void saveThemeToSharedPref(bool value){
    _sharedPrefObject.setBool("themeData", value);
  }

  // okuma metodu
  Future<void> loadThemeFromSharedPref() async {
    // await createSharedPrefObject();

    _isGreen = _sharedPrefObject.getBool("themeData")?? true;

  }
}
