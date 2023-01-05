import 'mudur.dart';
import 'personel.dart';
import 'isci.dart';
import 'ogretmen.dart';

void main(){
  // personel görünümlü işçi ve öğretmen
  // nesnelerini polymorphism ile oluşturalım
  Personel ogretmen = Ogretmen();
  Personel isci = Isci();

  var mudur = Mudur();
  mudur.terfiEttir(ogretmen);
  mudur.terfiEttir(isci);
}
