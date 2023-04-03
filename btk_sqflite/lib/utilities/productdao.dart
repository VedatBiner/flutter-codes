import '../utilities/dbhelper.dart';
import '../models/product.dart';

class Productdao {

  // Tüm ürünleri listele
  Future<List<Product>> getProducts() async {
    // veri tabanına erişelim
    var db = await DbHelper.veritabaniErisim();
    // sorgu yapalım
    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM products");
    // alan bilgilerini alalım ve nesne oluşturalım
    return List.generate(maps.length, (i) {
      // maps içine gelen bilgileri satır satır alalım
      var satir = maps[i];
      // nesneye dönüştürelim
      return Product(
        satir["id"],
        satir["name"],
        satir["description"],
        satir["unitPrice"],
      );
    });
  }

  // Güncelleme metodu
  Future<void> updateRecord(int id,String name, String description, double unitPrice) async {
    // veri tabanına erişelim
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = <String, dynamic>{};
    bilgiler["name"] = name;
    bilgiler["description"] = description;
    bilgiler["unitPrice"] = unitPrice;
    await db
        .update("products", bilgiler, where: "id=?", whereArgs: [id]);
  }

  // Kayıt ekleme metodu
  Future<void> insertRecord(String name, String description, double unitPrice) async {
    // veri tabanına erişelim
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = <String, dynamic>{};
    bilgiler["name"] = name;
    bilgiler["description"] = description;
    bilgiler["unitPrice"] = unitPrice;
    await db.insert("products", bilgiler);
  }

  // Kayıt silme metodu
  Future<void> deleteRecord(id) async {
    // veri tabanına erişelim
    var db = await DbHelper.veritabaniErisim();
    // kaydı silelim
    await db.delete("products", where: "id=?", whereArgs: [id]);
  }

}
