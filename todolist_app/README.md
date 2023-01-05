# todolist_app

## Uygulama Teması
Önce Uygulmamızın teması oluşturuluyor.\
![ScreenShot](screen_shots/img-01.png)
Kartlarımız oluştu. (01-Card Branch)\
![ScreenShot](screen_shots/img-02.png)\
Basit bir veri tabanı görevi görecek liste ile kart maddelerini yazalım. (02-SimpleDB Branch)\
![ScreenShot](screen_shots/img-03.png)\
**Provider** paketi kullanıp, Sayfa başlığı ve liste eleman sayısının otomatik güncellenmesi sağlandı.\
![ScreenShot](screen_shots/img-04.png)\
Görev tamamlanınca üzeri çizilsin, buton rengi değişsin, basılı görünümü değişsin\
![ScreenShot](screen_shots/img-05.png)\
Yeni görev eklenmesi. (05-AddTask Branch)\
![ScreenShot](screen_shots/img-06.png)
![ScreenShot](screen_shots/img-07.png)\
Seçilen görevin Silinmesi. (06-DeleteTask Branch)\
Seçilen görev parmak veya mouse ile sola çekiliyor.\
![ScreenShot](screen_shots/img-08.png)
![ScreenShot](screen_shots/img-09.png)\
Renk temasını değiştirmek için bir buton eklendi. (07-Settings Branch)\
Kırmızı yeşil renk değişimi yapıldı. Bu renk değişimi içinde ikinci bir provider kullanıldı. Yani MultiProvider Widget kullanıldı.\
![ScreenShot](screen_shots/img-10.png)
![ScreenShot](screen_shots/img-11.png)\
![ScreenShot](screen_shots/img-12.png)
![ScreenShot](screen_shots/img-13.png)\
Refactoring ile bazı düzeltmeler yapıldı. (08-Refactoring Branch)\
Shared Preferences ile en son kullanılan tema bilgisi cihazda tutuldu.
(09-SharedPreferences Branch)<BR>
Örneğin kırmızı tema ile kapatılan uygulama tekrar başlatıldığında yeşil
değil, kırmızı tema ile başladı.<BR>
Listemizi sıfırladık. Uygulama içindeki hazır listeyi iptal ettik. (10-SharedPreferencesList Branch)<BR>
Kendi bilgilerimizi kaydedip çıktık. Uygulamayı tekrar çalıştırınca kaydettiğimz hali ile geldi. <BR>
![ScreenShot](screen_shots/img-14.png)
![ScreenShot](screen_shots/img-15.png)
Birden çok provider yayını için **Provider2** widget kullanıldı. (11-Provider-EkBugFix Branch)
Aynı kayıttan çok kez girildiğinde key bilgisinin tek olması sağlandı.<BR>