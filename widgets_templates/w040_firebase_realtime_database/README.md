# firebase_app

Firebase realtime Database template app

* <B>Firebase setup</B><BR>
1 - <B>Pubspec.yaml</B> içine aşağıdaki kütüphaneler eklenir.
  * firebase_core:
  * firebase_database: 
  <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w040_firebase_realtime_database/screen_shots/img-01.png" height="300em"/> <BR>
2 - <B>main.dart</> dosyasının import bölümü ve en başı aşağıdaki kütüphaneler mutlaka olmalıdır.<BR>
  * import 'package:firebase_core/firebase_core.dart';
  * import 'package:firebase_database/firebase_database.dart';

  * void main() async {
    * WidgetsFlutterBinding.ensureInitialized();
    * await Firebase.initializeApp();
    * runApp(const MyApp());
  * }
  <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w040_firebase_realtime_database/screen_shots/img-02.png" height="400em"/> <BR>
3 - 
  



