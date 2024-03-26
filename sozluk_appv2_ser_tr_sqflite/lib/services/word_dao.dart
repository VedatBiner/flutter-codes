import '../models/sql_word_model.dart';
import 'db_helper.dart';

class Worddao {
  /// Tüm kelimeleri listele
  Future<List<SqlWords>> getWords() async {
    /// veri tabanına erişelim
    var db = await DbHelper.veritabaniErisim();

    /// sorgu yapalım
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM words");

    /// alan bilgilerini alalım ve nesne oluşturalım
    return List.generate(maps.length, (i) {
      /// maps içine gelen bilgileri satır satır alalım
      var satir = maps[i];
      /// nesneye dönüştürelim
      return SqlWords(
        wordId : satir["wordId"],
        sirpca : satir["sirpca"],
        turkce : satir["turkce"],
        userEmail : satir["userEmail"],
      );
    });
  }

  /// Güncelleme metodu
  Future<void> updateRecord(
      String wordId, String sirpca, String turkce, String userEmail) async {
    /// veri tabanına erişelim
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = <String, dynamic>{};
    bilgiler["sirpca"] = sirpca;
    bilgiler["turkce"] = turkce;
    bilgiler["userEmail"] = userEmail;
    await db.update("words", bilgiler, where: "id=?", whereArgs: [wordId]);
  }

  /// Kayıt ekleme metodu
  Future<void> insertRecord(
      String sirpca, String turkce, String userEmail) async {
    /// veri tabanına erişelim
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = <String, dynamic>{};
    bilgiler["sirpca"] = sirpca;
    bilgiler["turkce"] = turkce;
    bilgiler["userEmail"] = userEmail;
    await db.insert("words", bilgiler);
  }

  /// Kayıt silme metodu
  Future<void> deleteRecord(wordId) async {
    /// veri tabanına erişelim
    var db = await DbHelper.veritabaniErisim();
    /// kaydı silelim
    await db.delete("words", where: "id=?", whereArgs: [wordId]);
  }
}
