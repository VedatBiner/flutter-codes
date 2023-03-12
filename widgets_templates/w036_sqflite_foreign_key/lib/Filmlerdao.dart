import '../Filmler.dart';
import '../Kategoriler.dart';
import '../VeritabaniYardimcisi.dart';
import '../Yonetmenler.dart';

class Filmlerdao {
  // SQL sorgusu DB Browser 'daki hali
  //SELECT * FROM filmler,kategoriler,yonetmenler
  //WHERE filmler.kategori_id= kategoriler.kategori_id
  //and filmler.yonetmen_id = yonetmenler.yonetmen_id

  Future<List<Filmler>> tumFilmler() async {
    // veri tabanı erişimi
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    // sorgu oluşturma
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM filmler,kategoriler,yonetmenler "
        "WHERE filmler.kategori_id= kategoriler.kategori_id and filmler.yonetmen_id = yonetmenler.yonetmen_id");

    return List.generate(maps.length, (i) {
      var satir = maps[i];

      var k = Kategoriler(satir["kategori_id"], satir["kategori_ad"]);
      var y = Yonetmenler(satir["yonetmen_id"], satir["yonetmen_ad"]);
      var f = Filmler(satir["film_id"], satir["film_ad"], satir["film_yil"],
          satir["film_resim"], k, y);

      return f;  // f nesnesini listeleyip gönder
    });
  }
}
