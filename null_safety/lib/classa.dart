import 'interface1.dart';

class ClassA implements Interface1{
  @override
  int degisken = 10;

  @override
  void metod1() {
    print("İnterface 1 - Merhaba");
  }

  @override
  String metod2() {
    return "Interface çalışması";
  }

}
