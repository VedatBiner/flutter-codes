import '../soru.dart';

class TestVeri{

  int _soruIndex = 0;

  final List<Soru> _soruBankasi = [
    Soru(soruMetni: "Titanic gelmiş geçmiş en büyük gemidir.", soruYaniti: false),
    Soru(soruMetni: "Dünyadaki tavuk sayısı insan sayısından fazladır.", soruYaniti: true),
    Soru(soruMetni: "Kelebeklerin ömrü bir gündür.", soruYaniti: false),
    Soru(soruMetni: "Dünya Düzdür.", soruYaniti: false),
    Soru(soruMetni: "Kaju fıstığı aslında bir meyvenin sapıdır.", soruYaniti: true),
    Soru(soruMetni: "Fatih Sultan Mehmet hiç patates yememiştir.", soruYaniti: true)
  ];

  // getter tanımlanıyor. Dışarıdan çağırıldığında soru metni dönecek.
  String getSoruMetni(){
    return _soruBankasi[_soruIndex].soruMetni;
  }

  // Soru yanıtı için getter
  bool getSoruYaniti(){
    return _soruBankasi[_soruIndex].soruYaniti;
  }

  // sonraki soruya geçiliyor ve hata kontrolü yapılıyor.
  void sonrakiSoru(){
    if (_soruIndex < _soruBankasi.length -1){
      _soruIndex++;
    }
  }

  // test bitti ise dialog kutusu çıkarmak için kontrol.
  bool testBittiMi(){
    if(_soruIndex >= _soruBankasi.length - 1){
      return true;
    } else {
      return false;
    }
  }

  void testiSifirla(){
    _soruIndex = 0;
  }

}
