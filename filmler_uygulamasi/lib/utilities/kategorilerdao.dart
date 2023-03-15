import '../models/kategoriler.dart';
import 'dbhelper.dart';

class Kategorilerdao {

  Future<List<Kategoriler>> tumKategoriler() async {

    var db = await DbHelper.veritabaniErisim();

    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT * FROM kategoriler");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kategoriler(satir["kategori_id"], satir["kategori_ad"]);
    });
  }

}