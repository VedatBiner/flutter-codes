# firebase_app

Firebase realtime Database template app

* <B>Firebase setup</B><BR>
1 - <B>Pubspec.yaml</B> içine aşağıdaki kütüphaneler eklenir. <BR>
  firebase_core: <BR>
  firebase_database: <BR>
  <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w040_firebase_realtime_database/screen_shots/img-01.png" height="300em"/> <BR>
2 - <B>main.dart</> dosyasının import bölümü ve en başı aşağıdaki kütüphaneler mutlaka olmalıdır.<BR>
  import 'package:firebase_core/firebase_core.dart'; <BR>
  import 'package:firebase_database/firebase_database.dart'; <BR>
  void main() async { <BR>
    WidgetsFlutterBinding.ensureInitialized(); <BR>
    await Firebase.initializeApp(); <BR>
    runApp(const MyApp()); <BR>
  } <BR>
  <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w040_firebase_realtime_database/screen_shots/img-02.png" height="400em"/> <BR>
3 - 
  



