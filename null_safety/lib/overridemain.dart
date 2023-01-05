import 'hayvan.dart';
import 'kedi.dart';
import 'kopek.dart';
import 'memeli.dart';

void main(){
  var hayvan = Hayvan(); // nesne oluştu
  hayvan.sesCikar();
  var memeli = Memeli();
  memeli.sesCikar();
  var kedi = Kedi();
  kedi.sesCikar();
  var kopek = Kopek();
  kopek.sesCikar();
}
