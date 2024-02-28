# sozluk_app_ser_tr_fbfs

Sırpça-Türkçe Sözlük Uygulaması<BR>
Firebase kullanılarak kelimeler Firebase Firestore 'a aktarılıyor. 
Burada amaç hem uygulamadan hem de web 'den veri girişini sağlamak.<BR>
- Burada kelimeler Firebase Firestore 'a aktarılıyor. 
- Aynı kelime girişi var mı kontrol ediliyor.
- Kelime silme ve düzeltme yapılabiliyor. 
- Hem Card hem de List olarak görünüm değiştirilebiliyor. 
- Dil değişimleri yapılabiliyor. Bu Düzeltme sayfası ve Liste görünümünde de gerçekleşiyor.
- Dark / Light mode tema Slider menüden değiştirilebiliyor.
- Detaylı kelime bilgisi görülüp, hem buton ile hem de slider ile kelimeler arası geçiş yapılıyor. 
- Slider menü ile yardımcı gramer kuralları görülebiliyor.
- Erişim kontrolü için Google Sign In ve e-mail password erişimi eklendi. 
- Email adresi ile kayıt işlemi için mail adresi doğru formatta mı ? 
- Şifreler 8 karakterden büyük mü? 
- Şifreler eşleşiyor mu? gibi kontroller hem login hem de register sayfasından yapılıyor.
- Sözlük sayfasında rahat hareket için scrollbar eklendi.
- Kelime girişleri küçük harf ile başlasa bile büyük harfe çevriliyor.
- Arama sayfası ile herhangi bir kelime sözlükte var mı aranabiliyor.
- Firebase Hosting ile Web 'den de kullanım sağlandı. <BR>

Sorunlar<BR>
- Web erişiminde sorun var.
- Firebase ile web erişimde Google hesabı ile erişim de sorun var. <BR>

Yapılacaklar ve Planlananlar<BR>
- İngilizce, İspanyolca ve Almanca içinde aynı yapı oluşturulabilir.
- Alfabetik index ile istenen harf ile başlayan bölüme geçiş yapılabilmesi araştırılabilir.
- Firestore 'dan bir kere okunup, veriler ön belleğe alınıp, sadece değişiklikler olunca 
  Firestore 'a kayıt yapılarak performans artışı sağlanabilir.
- JSON veya my SQL ile lokal veri yedeği tutulabilir. <BR>
<BR>

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
Bazı Ekran Görüntüleri (düzenlenecek)
<HR>
Login Penceresi 
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-01.png" height="400em"/>
Kayıt Penceresi
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-02.png" height="400em"/>
Ana Sayfa Sırpça-Türkçe Sözlük ile Card görünümünde açılıyor.
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-03.png" height="400em"/>
Drawer menü ile yardımcı bilgiler, tem değişimi ve çıkış yapılabiliyor. 
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-04.png" height="400em"/>
Dark tema ve Card görünümü
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-05.png" height="400em"/>
Türkçe-Sırpça Sözlük değişimi
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-06.png" height="400em"/>
Detaylı görünüm (Dark mode), yön düğmeleri ve sürükleme ile hareket sağlanıyor.
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-07.png" height="400em"/>
Detaylı görünüm (Light mode)
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-08.png" height="400em"/>
List görünüm (Light)
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-09.png" height="400em"/>
List görünüm (Dark)
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-10.png" height="400em"/>
Kelime düzeltme penceresi
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-11.png" height="400em"/>
Kelime silme sorusu
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-12.png" height="400em"/>
Yeni kelime giriş penceresi (Sırpça-Türkçe)
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-13.png" height="400em"/>
Yeni kelime giriş penceresi (Türkçe-Sırpça)
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-14.png" height="400em"/>
Örnek bir yardımcı sayfa
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-15.png" height="400em"/>
Bir başka yardımcı sayfa örneği
<img src="https://github.com/VedatBiner/flutter-codes/blob/master/sozluk_app_ser_tr_fbfs/screen_shots/img-16.png" height="400em"/>