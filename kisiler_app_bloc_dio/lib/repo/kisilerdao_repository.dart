import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../models/kisiler_cevap.dart';
import '../models/kisiler.dart';

class KisilerDaoRepository {

  List<Kisiler> parseKisilerCevap(String cevap) {
    return KisilerCevap.fromJson(json.decode(cevap)).kisiler;
  }

  // Kayıt metodu
  Future<void> kisiKayit(String kisi_ad, String kisi_tel) async {
    var url = "http://kasimadalan.pe.hu/kisiler/insert_kisiler.php";
    // POST işlemi için veriyi oluşturduk
    var veri = {
      "kisi_ad": kisi_ad,
      "kisi_tel": kisi_tel,
    };
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    log("Kisi ekle : ${cevap.data.toString()}");
  }

  // Güncelleme metodu
  Future<void> kisiGuncelle(
    int kisi_id,
    String kisi_ad,
    String kisi_tel,
  ) async {
    var url = "http://kasimadalan.pe.hu/kisiler/update_kisiler.php";
    // POST işlemi için veriyi oluşturduk
    var veri = {
      "kisi_id": kisi_id,
      "kisi_ad": kisi_ad,
      "kisi_tel": kisi_tel,
    };
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    log("Kisi güncelle : ${cevap.data.toString()}");
  }

  // tüm kişileri listleyelim
  Future<List<Kisiler>> tumKisileriAl() async {
    var url = "http://kasimadalan.pe.hu/kisiler/tum_kisiler.php";
    var cevap = await Dio().get(url);
    return parseKisilerCevap(cevap.data.toString());
  }

  // arama işlemi
  Future<List<Kisiler>> kisiAra(String aramaKelimesi) async {
    var url = "http://kasimadalan.pe.hu/kisiler/tum_kisiler_arama.php";
    // POST işlemi için veriyi oluşturduk
    var veri = {"kisi_ad": aramaKelimesi};
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    return parseKisilerCevap(cevap.data.toString());
  }

  // silme işlemi
  Future<void> kisiSil(int kisi_id) async {
    var url = "http://kasimadalan.pe.hu/kisiler/delete_kisiler.php";
    // POST işlemi için veriyi oluşturduk
    var veri = {"kisi_id": kisi_id};
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    log("Kisi sil : ${cevap.data.toString()}");
  }
}

