import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier{
  /// varsayılan provider değişkeni
  Locale current = const Locale("tr");

  /// Türkçe Fonksiyonu
  void setTurkish(){
    current = const Locale("tr");
    notifyListeners();
  }

  /// İngilizce Fonksiyonu
  void setEnglish(){
    current = const Locale("en");
    notifyListeners();
  }

}
