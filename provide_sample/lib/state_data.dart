import 'package:flutter/material.dart';

class StateData with ChangeNotifier{
  String sehir = "Ankara";
  String ilce = "Yenimahalle";
  String mahalle = "Demetevler";

  void newCity(String city){
    sehir = city;
    // değişikliği haber verecek
    notifyListeners();
  }
}