# sozluk_app_ser_tr_fbfs

Sırpça-Türkçe Sözlük Uygulaması
Firebase Firestore kullanılarak kelimeler Firebase 'e aktarılıyor.
Burada amaç hem uygulamadan hem de web 'den veri girişini sağlamak'
<BR>
Burada kelimeler Firebase Firestore 'a aktarılıyor. Aynı kelime girişi var mı 
kontrol ediliyor. Kelime silme ve düzeltme yapılabiliyor. Detaylı kelime bilgisi 
görülüp, hem buton ile hem de slider ile kelimeler arası geçiş yapılıyor. Dark ve 
Light mode tema Drawer menüden değiştirilebiliyor.
Erişim kontrolü için Google Sign In ve e-mail password erişimi eklendi. Email adresi ile kayıt
işlemi için mail adresi doğru formatta mı ? şifreler 8 karakterden büyük mü? şifreler eşleşiyor mu?
kontrolleri yapıldı.
*** gmail ile login şimdilik iptal ***
Sırpça-Türkçe ve Türkçe-Sırpça dil değişimleri ekleniyor.
Card Görünümü Liste Görünümü seçimleri yapılıyor.
Scroollbar eklendi. Kelimelerin baş harflerinin küçük bile girilse büyük yapılması sağlandı.
<HR>

Kullanılan Paketler: <BR>
- firebase_core       : Firebase temel paket
- cloud firestore     : Firestore erişim paketi
- Firebase Auth       : Mail ve Google hesabı ile giriş yöntemi
- flag                : Bayrak gösterimi  için gerekli paket 
- google fonts        : Ekstra font kullanımı gereken paket
- flutter toast       : toast mesaj için kullanılan paket
- provider            : dark/light mode geçişleri için kullanıldı.
- carousel_slider     : detail_page.dart dosyasında kelimeleri kaydırma için kullanıldı.
- package_info_plus   : Versiyon bilgilerini almak için kullanıldı.
- draggable_scrollbar : Scrollbar için gerekli olan kitaplık
<BR>
Ekran Görüntüleri (düzenlenecek)
<HR>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-01.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-02.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-03.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-04.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-05.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-06.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-07.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-08.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-09.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-10.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-11.png" height="400em"/>
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-12.png" height="400em"/>