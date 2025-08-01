// 📃 lib/providers/word_count_provider.dart
// eski word_count_provider

import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';

class MalzemeCountProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void setCount(int newCount) {
    _count = newCount;
    notifyListeners();
  }

  /// 📌 Veritabanından toplam kelime sayısını alır ve notify eder
  Future<void> updateCount() async {
    final newCount = await DbHelper.instance.countWords();
    _count = newCount;
    notifyListeners();
  }
}
