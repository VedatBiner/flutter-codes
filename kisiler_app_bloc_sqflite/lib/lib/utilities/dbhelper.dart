import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final veritabaniAdi = "rehber.sqlite";
  static Future<Database> veritabaniErisim() async {
    String veritabaniYolu = join(await getDatabasesPath(), veritabaniAdi);
    if (await databaseExists(veritabaniYolu)) {
      log("Veri tabanı zaten var kopyalamaya gerek yok.");
    } else {
      ByteData data = await rootBundle.load("assets/database/$veritabaniAdi");
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(veritabaniYolu).writeAsBytes(bytes, flush: true);
      log("veri tabanı kopyalandı...");
    }
    return openDatabase(veritabaniYolu);
  }
}
