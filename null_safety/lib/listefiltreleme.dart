import 'ogrenciler.dart';

void main(){
// nesne oluşturalım
  var o1 = Ogrenciler(100, "Mehmet", "10F");
  var o2 = Ogrenciler(200, "Vedat", "12A");
  var o3 = Ogrenciler(300, "Zeynep", "9C");
  var ogrenciler = <Ogrenciler>[];
  // listeye ekleyelim
  ogrenciler.add(o1);
  ogrenciler.add(o2);
  ogrenciler.add(o3);
  // filtreleme işlemi
  Iterable<Ogrenciler> filtrelenenListe = ogrenciler.where((ogrenci) {
    return ogrenci.adi.contains("t");
  });
  ogrenciler = filtrelenenListe.toList();
  print("Liste");
  for(var o in ogrenciler){
    print("***************");
    print("Öğrenci No : ${o.no}");
    print("Öğrenci Adı : ${o.adi}");
    print("Öğrenci Sınıfı : ${o.sinif}");
  }
}
