# firebase_app

Firebase realtime Database template app

* <B>Firebase setup</B><BR>
1 - <B>Pubspec.yaml</B> içine aşağıdaki kütüphaneler eklenir. <BR>
  firebase_core: <BR>
  firebase_database: <BR>
  <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w040_firebase_realtime_database/screen_shots/img-01.png" height="200em"/> <BR>
2 - <B>main.dart</> dosyasının import bölümü ve en başı aşağıdaki kütüphaneler mutlaka olmalıdır.<BR>
  import 'package:firebase_core/firebase_core.dart'; <BR>
  import 'package:firebase_database/firebase_database.dart'; <BR>
  void main() async { <BR>
    WidgetsFlutterBinding.ensureInitialized(); <BR>
    await Firebase.initializeApp(); <BR>
    runApp(const MyApp()); <BR>
  } <BR>
  <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w040_firebase_realtime_database/screen_shots/img-02.png" height="250em"/> <BR>
3 - https://console.firebase.google.com/ sayfasında proje oluşturma oluşturulur. <BR>
4 - Android Uygulaması Bağlama<BR>
* <B>Android</B> >> <B>App</B> >> <B>Build.gradle</B> dosyası içinden uygulama addı kopyalanıp, Firebase console sayfasına eklenir. Ayrıca burada <b>minSdkVersion 21 </b> yapılmalıdır. <BR>
  <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w040_firebase_realtime_database/screen_shots/img-03.png" height="300em"/> <BR>
5 - <B>Console</B> sayfasında <B>Register App</B> ile uygulama kaydedilir. Download <B>google-services.json></B> düğmesi ile dosya indirilip, <B>Android</B> >> <B>App</B> dizinine 
kopyalanır. <BR>
6 - <B>classpath 'com.google.gms:google-services:4.3.15' </B>satırını, android altındaki build.gradle içine ekliyoruz.<BR>
  <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w040_firebase_realtime_database/screen_shots/img-04.png" height="150em"/> <BR>
7 - <B>id 'com.google.gms.google-services'</B> (bu dosyayı apply plugin: 'com.google.gms.google-services' şeklinde yapıştırabiliriz.) ve <B>implementation platform('com.google.firebase:firebase-bom:31.2.3') </B> 
satırlarını ilgili yerlere kopyalayalım. <B>Android</B> >> <B>App</B> altındaki <B>build.gradle</B> dosyasına yapıştıracağız. <BR>
  <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w040_firebase_realtime_database/screen_shots/img-05.png" height="150em"/> <BR>
  <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w040_firebase_realtime_database/screen_shots/img-06.png" height="100em"/> <BR>
  



