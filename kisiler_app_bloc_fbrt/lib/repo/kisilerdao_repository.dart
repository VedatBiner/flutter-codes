import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';

class KisilerDaoRepository {

  // referans kayıt
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler");

  // Kayıt metodu
  Future<void> kisiKayit(String kisi_ad, String kisi_tel) async {
    var bilgi = <String, dynamic>{}; // Map yeni gösterim
    bilgi["kisi_id"] = "";
    bilgi["kisi_ad"] = kisi_ad;
    bilgi["kisi_tel"] = kisi_tel;
    refKisiler.push().set(bilgi);
  }

  // Güncelleme metodu
  Future<void> kisiGuncelle(
    String kisi_id,
    String kisi_ad,
    String kisi_tel,
  ) async {
    var bilgi = <String, dynamic>{}; // Map yeni gösterim
    // Güncellemede kisi_id gerekmiyor
    bilgi["kisi_ad"] = kisi_ad;
    bilgi["kisi_tel"] = kisi_tel;
    refKisiler.child(kisi_id).update(bilgi);
  }

  // silme işlemi
  Future<void> kisiSil(String kisi_id) async {
    refKisiler.child(kisi_id).remove();
  }
}

