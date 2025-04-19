// 📃 lib/providers/word_count_provider.dart

import 'package:flutter/foundation.dart';

import '../db/word_database.dart';

class WordCountProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void setCount(int newCount) {
    _count = newCount;
    notifyListeners();
  }

  /// 📌 Veritabanından toplam kelime sayısını alır ve notify eder
  Future<void> updateCount() async {
    final newCount = await WordDatabase.instance.countWords();
    _count = newCount;
    notifyListeners();
  }
}
