import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/kisilerdao_repository.dart';

class KisiKayitCubit extends Cubit<void> {
  KisiKayitCubit() : super(0);

  var krepo = KisilerDaoRepository();

  // kayıt verisi repoya gönderiliyor
  Future<void> kayit(String kisi_ad, String kisi_tel) async {
    await krepo.kisiKayit(kisi_ad, kisi_tel);
  }

}
