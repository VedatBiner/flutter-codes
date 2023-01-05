import 'yonetmenler.dart';
import 'kategoriler.dart';

class Filmler{
  int film_id;
  String film_adi;
  int film_yil;
  Kategoriler kategori;
  Yonetmenler yonetmen;

  Filmler(
      this.film_id, this.film_adi, this.film_yil, this.kategori, this.yonetmen);
}
