/// bu dosya şimdilik kullanılmayacak
/// <----- word_count_provider.dart ----->
library;

import 'package:flutter/material.dart';

class WordCountProvider with ChangeNotifier {
  int _documentCount = 0;

  int get documentCount => _documentCount;

  void setDocumentCount(int count) {
    _documentCount = count;
    notifyListeners();
  }
}
