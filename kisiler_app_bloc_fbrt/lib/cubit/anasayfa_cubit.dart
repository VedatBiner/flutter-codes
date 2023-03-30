import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/kisilerdao_repository.dart';
import '../models/kisiler.dart';

class AnasayfaCubit extends Cubit<List<Kisiler>>{

  AnasayfaCubit() : super(<Kisiler>[]);

  var krepo = KisilerDaoRepository();
  // referans kayıt
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler");

  // Tüm kişileri listeleyelim
  Future<void> kisileriYukle() async {
    refKisiler.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value as dynamic;
      if(gelenDegerler != null){
        var liste = <Kisiler>[];
        gelenDegerler.forEach((key, nesne){
          var kisi = Kisiler.fromJson(key, nesne);
          // listeye ekleyelim
          liste.add(kisi);
        });
        // listeyi ara yüze gönderelim
        emit(liste);
      }
    });
  }

  // arama metodu
  Future<void> ara(String aramaKelimesi) async {
    refKisiler.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value as dynamic;
      if(gelenDegerler != null){
        var liste = <Kisiler>[];
        gelenDegerler.forEach((key, nesne){
          var kisi = Kisiler.fromJson(key, nesne);
          // arama sorgusu
          if (kisi.kisi_ad.contains(aramaKelimesi)){
            // listeye ekleyelim
            liste.add(kisi);
          }
        });
        // listeyi ara yüze gönderelim
        emit(liste);
      }
    });
  }

  // silme işlemi
  Future<void> sil(String kisi_id) async {
    // kaydı sildik
    await krepo.kisiSil(kisi_id);
  }

}