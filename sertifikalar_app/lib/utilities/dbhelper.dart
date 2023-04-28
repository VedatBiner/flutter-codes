import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String veritabaniAdi = "sertifikalar.sqlite";

  static Future<Database> veritabaniErisim() async {
    String veritabaniYolu = join(await getDatabasesPath(), veritabaniAdi);

    if (await databaseExists(veritabaniYolu)) {
      // Veritabanı var mı yok mu kontrolü
      log("Veri tabanı zaten var.Kopyalamaya gerek yok");
    } else {
      //asset 'ten veritabanının alınması
      ByteData data = await rootBundle.load("assets/database/$veritabaniAdi");
      // Veritabanının kopyalama için byte dönüşümü
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Veritabanının kopyalanması.
      await File(veritabaniYolu).writeAsBytes(bytes, flush: true);
      log("Veri tabanı kopyalandı");
    }
    //Veritabanını açıyoruz.
    return openDatabase(veritabaniYolu);
  }
}