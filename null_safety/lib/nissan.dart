import 'araba.dart';

class Nissan extends Araba{
  String model;

  // kalıtım ilişkisi bu şekilde  oluşturuldu
  Nissan(
      this.model,
      String kasaTipi, // Araba 'dan gelen miras
      String renk, // Arac 'tan gelen miras
      String vites) // Arac 'tan gelen miras
      : super(kasaTipi, renk, vites);
}
