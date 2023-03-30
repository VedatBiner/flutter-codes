import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/kisilerdao_repository.dart';
import '../models/kisiler.dart';

class AnasayfaCubit extends Cubit<List<Kisiler>>{

  AnasayfaCubit() : super(<Kisiler>[]);

  var krepo = KisilerDaoRepository();

  Future<void> kisileriYukle() async {
    var liste = await krepo.tumKisileriAl();
    emit(liste);
  }

  Future<void> ara(String aramaKelimesi) async {
    var liste = await krepo.kisiAra(aramaKelimesi);
    emit(liste);
  }

  // silme işlemi
  Future<void> sil(int kisi_id) async {
    // kaydı sildik
    await krepo.kisiSil(kisi_id);
    // arayüzü güncelledik
    await kisileriYukle();
  }

}
