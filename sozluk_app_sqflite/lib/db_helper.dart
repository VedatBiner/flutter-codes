import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String veritabaniAdi = "sozluk.sqlite";

  // Veri tabanı erişim metodu
  static Future<Database> veritabaniErisim() async {
    // veri tabanı uygulama içine kopyalandı mı ?
    // veri tabanı yolunu alalım
    String veritabaniYolu = join(await getDatabasesPath(), veritabaniAdi);
    // veri tabanı kopyalandı mı ?
    if (await databaseExists(veritabaniYolu)) {
      log("Veri tabanı zaten var, kopyalamaya gerek yok");
    } else {
      // kopyalama için önce byte dosyaya dönüştürmek gerekiyor.
      ByteData data = await rootBundle.load("veritabani/$veritabaniAdi");
      // byte 'a dönüştürme
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(veritabaniYolu).writeAsBytes(bytes,flush: true);
      log("Veri tabanı kopyalandı.");
    }
    // tekrar veri tabanına erişiliyor
    return openDatabase(veritabaniYolu);
  }
}