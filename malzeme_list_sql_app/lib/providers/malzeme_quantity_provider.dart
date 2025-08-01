// 📃 <----- malzeme_quantity_provider.dart ----->
//
// Malzeme miktarlarını artırıp azaltmak için Provider sınıfı

import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/malzeme_model.dart';

class MalzemeQuantityProvider extends ChangeNotifier {
  final Map<int, int> _quantities =
      {}; // 🔹 Her malzemenin ID 'sine karşılık gelen miktarı tutar

  Map<int, int> get quantities => _quantities;

  /// 📌 Verilen ID 'li malzemenin miktarını 1 artırır
  Future<void> increaseQuantity(int id) async {
    final malzeme = await DbHelper.instance.getMalzemeById(id);
    if (malzeme != null) {
      final updated = malzeme.copyWith(miktar: (malzeme.miktar ?? 0) + 1);
      await DbHelper.instance.updateWord(updated);
      _quantities[id] = updated.miktar ?? 0;
      notifyListeners();
    }
  }

  /// 📌 Verilen ID 'li malzemenin miktarını 1 azaltır (sıfırın altına düşmez)
  Future<void> decreaseQuantity(int id) async {
    final malzeme = await DbHelper.instance.getMalzemeById(id);
    if (malzeme != null) {
      int current = malzeme.miktar ?? 0;
      if (current > 0) {
        final updated = malzeme.copyWith(miktar: current - 1);
        await DbHelper.instance.updateWord(updated);
        _quantities[id] = updated.miktar ?? 0;
        notifyListeners();
      }
    }
  }

  /// 📌 Belirli bir malzemenin güncel miktarını döner (Provider üzerinden)
  int getQuantity(int id, int fallback) {
    return _quantities[id] ?? fallback;
  }

  /// 📌 Başlangıçta miktarları yüklemek için
  Future<void> loadQuantities(List<Malzeme> malzemeler) async {
    for (var m in malzemeler) {
      _quantities[m.id!] = m.miktar ?? 0;
    }
    notifyListeners();
  }
}
