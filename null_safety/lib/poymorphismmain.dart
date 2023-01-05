import 'personel.dart';
import 'isci.dart';
import 'mudur.dart';
import 'ogretmen.dart';

void main(){
  var mudur = Mudur();
  // personel üst sınıf, ogretmen alt sınıf
  Personel ogretmen = Ogretmen();
  // personel görünecek ama isci özellikleri taşıyacak
  Personel isci = Isci();

  mudur.iseAl(ogretmen);
  mudur.iseAl(isci);
}
