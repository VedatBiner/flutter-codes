import 'yonetmenler.dart';
import 'filmler.dart';
import 'kategoriler.dart';

void main(){
  var k1 = Kategoriler(1, "Dram");
  var k2 = Kategoriler(2, "Bilim Kurgu");
  var y1 = Yonetmenler(1, "Cristopher Nolan");
  var y2 = Yonetmenler(2, "Quentin Tarantino");
  var f1 = Filmler(1, "Django", 2013, k1, y2);
  print("film id: ${f1.film_id}");
  print("film adı : ${f1.film_adi}");
  print("filmin yılı : ${f1.film_yil}");
  print("filmin kategorisi : ${f1.kategori.kategori_ad}");
  print("filmin yöntemeni : ${f1.yonetmen.yonetmen_ad}");
}
