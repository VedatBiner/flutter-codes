import 'package:flutter_bloc/flutter_bloc.dart';
import 'matematik_repository.dart';

class AnasayfaCubit extends Cubit<int> {
  AnasayfaCubit() : super(0);

  var mrepo = MatematikRepository();

  void toplamaYap(String alinanSayi1, String alinanSayi2) {
    emit(mrepo.topla(alinanSayi1, alinanSayi2));
  }

  void carpmaYap(String alinanSayi1, String alinanSayi2) {
    emit(mrepo.carp(alinanSayi1, alinanSayi2));
  }

}
