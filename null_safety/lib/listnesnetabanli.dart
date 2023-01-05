import 'ogrenciler.dart';
void main(){
  // nesne oluşturalım
  var o1 = Ogrenciler(100, "Mehmet", "10F");
  var o2 = Ogrenciler(300, "Vedat", "12A");
  var o3 = Ogrenciler(200, "Zeynep", "9C");
  var ogrenciler = <Ogrenciler>[];
  // listeye ekleyelim
  ogrenciler.add(o1);
  ogrenciler.add(o2);
  ogrenciler.add(o3);
  // listenin ilk hali
  print("Sırasız Liste");
  for(var o in ogrenciler){
    print("***************");
    print("Öğrenci No : ${o.no}");
    print("Öğrenci Adı : ${o.adi}");
    print("Öğrenci Sınıfı : ${o.sinif}");
  }
  print("\n");
  // Öğrenci no küçükten büyüğe sıralanacak
  Comparator<Ogrenciler> siralama1 = (x, y) => x.no.compareTo(y.no);
  ogrenciler.sort(siralama1);
  // numara sırası küçükten büyüğe
  print("Numara sırasına göre sıralı liste");
  for(var o in ogrenciler){
    print("***************");
    print("Öğrenci No : ${o.no}");
    print("Öğrenci Adı : ${o.adi}");
    print("Öğrenci Sınıfı : ${o.sinif}");
  }
  print("\n");
  // Öğrenci no büyükten küçüğe sıralanacak
  Comparator<Ogrenciler> siralama2 = (y, x) => x.no.compareTo(y.no);
  ogrenciler.sort(siralama2);
  // numara sırası küçükten büyüğe
  print("Numara sırasına göre sıralı liste");
  for(var o in ogrenciler){
    print("***************");
    print("Öğrenci No : ${o.no}");
    print("Öğrenci Adı : ${o.adi}");
    print("Öğrenci Sınıfı : ${o.sinif}");
  }
  print("\n");

  // Öğrenci adı büyükten küçüğe sıralanacak
  Comparator<Ogrenciler> siralama3 = (y, x) => x.adi.compareTo(y.adi);
  ogrenciler.sort(siralama3);
  // numara sırası küçükten büyüğe
  print("Numara sırasına göre sıralı liste");
  for(var o in ogrenciler){
    print("***************");
    print("Öğrenci No : ${o.no}");
    print("Öğrenci Adı : ${o.adi}");
    print("Öğrenci Sınıfı : ${o.sinif}");
  }
  print("\n");
}
















