/// <----- button_provider.dart ----->
/// card/list değişikliği için provider paketi kullanan metot
library;

import 'package:flutter/material.dart';

/// önce bir provider oluşturuyoruz.
/// tıklama durumu bu sınıf ile yönetiliyor.
class IconProvider extends ChangeNotifier {
  bool isIconChanged = false;

  void changeIcon() {
    isIconChanged = !isIconChanged;
    notifyListeners();
  }
}

