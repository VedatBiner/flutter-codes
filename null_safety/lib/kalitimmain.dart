import 'araba.dart';
import 'arac.dart';
import 'nissan.dart';

void main(){
  var araba = Araba("Sedan", "Kırmızı", "Otomatik");
  print(araba.kasaTipi);
  print(araba.vites);
  print(araba.renk);
  print("-----------------");

  var nissan = Nissan("Micra", "Sedan", "Manuel", "Beyaz");
  print(nissan.model);
  print(nissan.kasaTipi);
  print(nissan.vites);
  print(nissan.renk);

  var arac = Arac("Mavi", "Otomatik");
  arac.
}
