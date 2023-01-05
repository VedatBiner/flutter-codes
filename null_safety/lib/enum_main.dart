import 'konserveboyut.dart';

void main(){
  ucretAl(KonserveBoyut.orta);
}

void ucretAl(KonserveBoyut boyut){
  // konserve boyutuna göre ücretlendirme
  switch(boyut){
    case KonserveBoyut.kucuk:{
      print(20 * 30);
    }
    break;
    case KonserveBoyut.orta:{
      print(30 * 30);
    }
    break;
    case KonserveBoyut.buyuk:{
      print(40 * 30);
    }
    break;
  }
}