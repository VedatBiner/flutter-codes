import 'package:yasam_beklentisi/user_data.dart';

class Hesap{
  UserData _userData;
  Hesap(this._userData);

  double hesaplama(){
    double sonuc;
    sonuc = 90 + _userData.sporGunu - _userData.icilenSigara;
    sonuc = sonuc + (_userData.boy / _userData.kilo);
    if (_userData.seciliCinsiyet == "KADIN"){
      return sonuc + 3;
    } else {
      return sonuc;
    }
  }
}
