import 'package:flutter_bloc/flutter_bloc.dart';

class SayacCubit extends Cubit<int>{
  // varsayılan başlangıç değeri
  SayacCubit():super(0);

  void sayaciArttir(){
    // state enson gelen değeri temsil ediyor
    int sayac= state + 1;
    // tetikleme
    emit(sayac);
  }

  void sayaciAzalt(int miktar){
    int sayac= state - miktar;
    // tetikleme
    emit(sayac);
  }

}
