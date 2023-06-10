# w054_admob

Admob reklam sample
<HR>
Burada banner ve geçiş reklamı örneği var


<B>Kurulum Adımları</B><BR>
1. <B>Pubspec.yaml</B> içine <B>google_mobile_ads</B> kütüphanesi eklenir.<BR>
   <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w054_admob/screen_shots/img-01.png" height="150em"/> <BR>
2. <B>Android >> app >> src >> main</B> dizinindeki <B>AndroidManifest.xml</B> dosyasına aşağıdakiler eklenir. <BR>
   <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w054_admob/screen_shots/img-02.png" height="240em"/> <BR>
   <!-- Sample AdMob app ID: ca-app-pub-3940256099942544~3347511713 --> <BR>
   <meta-data <BR>
       android:name="com.google.android.gms.ads.APPLICATION_ID" <BR>
       android:value="ca-app-pub-3940256099942544~3347511713"/> <BR>
3. <B>Android >> app</B> altındaki <B>build.gradle</B> içine eklemek gerekebilir.<BR>
   <img src="https://github.com/VedatBiner/flutter-codes/blob/master/widgets_templates/w054_admob/screen_shots/img-03.png" height="300em"/> <BR>
   minSdkVersion 19<BR>
   multiDexEnabled true<BR>
   dexOptions { <BR>
   javaMaxHeapSize "4g" <BR>
   preDexLibraries = false <BR>
   } <BR>
4. sss
5. sss
6. 