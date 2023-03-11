import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class VeritabaniYardimcisi {
  static final String veritabaniAdi = "rehber.sqlite";

  // Veri tabanı erişim metodu
  static Future<Database> veritabaniErisim() async {
    // veri tabanı uygulama içine kopyalandı mı ?
    // veri tabanı yolunu alalım
    String veritabaniyolu = join(await getDatabasesPath(), veritabaniAdi);
    // veri tabanı kopyalandı mı ?
    if (await databaseExists(veritabaniyolu)) {
      log("Veri tabanı zaten var, kopyalamaya gerek yok");
    } else {
      // kopyalama için önce byte dosyaya dönüştürmek gerekiyor.
      ByteData data = await rootBundle.load("veritabani/$veritabaniAdi");
      // byte 'a dönüştürme
      List<int> bytes =
          data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
      await File(veritabaniyolu).writeAsBytes(bytes, flush: true);
      log("Veri tabanı kopyalandı.");
    }
    // tekrar veri tabanına erişiliyor
    return openDatabase(veritabaniyolu);
  }
}
