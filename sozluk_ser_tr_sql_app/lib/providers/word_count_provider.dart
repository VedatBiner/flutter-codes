// 📃 lib/providers/word_count_provider.dart

import 'package:flutter/foundation.dart';

class WordCountProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void setCount(int newCount) {
    _count = newCount;
    notifyListeners();
  }
}
