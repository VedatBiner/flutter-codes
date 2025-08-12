// 📃 lib/providers/word_count_provider.dart

// 📌 Dart paketleri
import 'package:flutter/foundation.dart';

/// 📌 Yardımcı yüklemeler burada
import '../services/db_helper.dart';

class WordCountProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void setCount(int newCount) {
    _count = newCount;
    notifyListeners();
  }

  /// 📌 Veritabanından toplam kelime sayısını alır ve notify eder
  Future<void> updateCount() async {
    final newCount = await DbHelper.instance.countRecords();
    _count = newCount;
    notifyListeners();
  }
}
