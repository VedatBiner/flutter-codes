import '../dbhelper.dart';
import 'bayraklar.dart';

class Bayraklardao {
  // rasgele 5 bayrak getirelim
  Future<List<Bayraklar>> rasgele5Getir() async {
    // veri tabanına erişelim
    var db = await DbHelper.veritabaniErisim();
    // sorgulama yapalım. 5 tane rasgele bayrak istiyoruz
    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM bayraklar ORDER BY RANDOM() LIMIT 5");
    // 5 bayrak önce listeye, Sonra nesneye dönüştürülecek
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Bayraklar(
        satir["bayrak_id"],
        satir["bayrak_ad"],
        satir["bayrak_resim"],
      );
    });
  }

  // yanlış seçenekleri alan bir metod oluşturalım
  // 3 yanlış seçenek gelecek, 1 seçenek doğru olacak
  Future<List<Bayraklar>> rasgele3YanlisGetir(int bayrakId) async {
    // veri tabanına erişelim
    var db = await DbHelper.veritabaniErisim();
    // sorgulama yapalım. 3 tane rasgele bayrak istiyoruz
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM bayraklar WHERE bayrak_id != $bayrakId ORDER BY RANDOM() LIMIT 3");
    // 5 bayrak önce listeye, Sonra nesneye dönüştürülecek
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Bayraklar(
        satir["bayrak_id"],
        satir["bayrak_ad"],
        satir["bayrak_resim"],
      );
    });
  }
}

