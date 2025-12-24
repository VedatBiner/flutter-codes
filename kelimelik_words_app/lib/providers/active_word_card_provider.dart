import 'package:flutter/material.dart';

class ActiveWordCardProvider extends ChangeNotifier {
  int? _activeWordId;

  int? get activeWordId => _activeWordId;

  void open(int id) {
    _activeWordId = id;
    notifyListeners();
  }

  void close() {
    _activeWordId = null;
    notifyListeners();
  }
}
