import 'package:shared_preferences/shared_preferences.dart';

void puanKontrol({
  required SharedPreferences prefs,
  required int enYuksekPuan,
  required int toplamPuan,
  required Function(int) saveEnYuksekPuan,
}) {
  if (toplamPuan > enYuksekPuan) {
    saveEnYuksekPuan(toplamPuan);
  }
}
