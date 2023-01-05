import 'isci.dart';
import 'personel.dart';
import 'ogretmen.dart';

class Mudur extends Personel{
  void iseAl(Personel p){
    p.iseAlindi();
  }
  void terfiEttir(Personel p){
    // tip kontrolü yapalım.
    if (p is Ogretmen){
      // p nesnesi Ogretmen'dir
      p.maasArttir();
    }
    if (p is Isci){
      // p nesnesi Isci 'dir
      print("İşçiler terfi alamaz");
    }
  }
}

