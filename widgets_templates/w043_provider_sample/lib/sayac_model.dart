import 'package:flutter/material.dart';

class SayacModel extends ChangeNotifier {
  int sayac = 0;

  // dinleme işlemi için metod
  int sayaciOku(){
    return sayac;
  }

  // tetikleme metotları
  void sayaciArttir(){
    sayac = sayac + 1;
    // tetiklemeyi gerçekleştir
    // dinleme tektiklendi
    notifyListeners();
  }

  // tetikleme metotları
  void sayaciAzalt(int miktar){
    sayac = sayac - miktar;
    // tetiklemeyi gerçekleştir
    // dinleme tektiklendi
    notifyListeners();
  }

}