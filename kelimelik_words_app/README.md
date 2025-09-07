# kelimelik_words_app

Kelimelik oyunu için basit bir sqflite uygulaması
bir chatGPT ortak çalışması :)

- SQfLite ile veri girişi yapılıyor. 
- Girilen verilerin yedekleri SQL, JSON ve CSV olarak alınabiliyor.
- Kelime ekleme, silme, güncelleme kontrolü var.
- Aynı kelime tekrar girilemiyor.
- Versiyon bilgisi var.
- Drawer menu ayrı dosyaya alındı
- Home_page daha sadeleşti
- Kelime kartına iki kez tıklanınca düzeltme ve silme butonları çıkıyor.
- Kart görünümü renklendirildi.
- Kelime eklemeye notification eklendi
- Kelime silmeye notification eklendi
- Kelime güncellemeye notification eklendi
- Kelime ekleme kutusu açılınca rama kutusu kapatılıyor.
- Biraz renklendirme yapıldı.
- Butonlar renklendirildi.
- Sık kullanılan renk ve stiller sabit dosyalara alındı. 
  Böylece renk değişimi tek yerden yapılabilecek.
- Türkçe sıralama yapıldı.
- Bazı notification hataları düzeltildi.
- Veri tabanı silme dialog kutusu düzeltildi
- Uygulama ikonu değiştirildi.
- Uygulama adı değiştirildi
- Fihrist ve klasik liste görünümü eklendi.
- iki kod da da tekrarlanan kelime silme dialog bölümü tek kod ile ortak kullanılır hale getirildi.
- veritabanı silme dialog box 'da önceki dialog ile birleştirilip, üç ayrı kodun aynı ortak dialog 
kutusunu kullanması sağlandı.
- Arama kutusu ikonları görselleştirildi.
- Silme ve düzenleme ikonları değiştirildi.
- FAB butonu biraz sola çekildi.
- Silme ve düzenleme ortak butonları tek dosyaya ayrıldı.
- JSON ve CSV yedek alma işlemi iki ayrı dosyaya ayrılıp, tek menü seçeneğine indirildi.
- Verilerin SQL 'den silinip, JSON ile yeniden yüklenmesi sağlandı.
- Verilerin silindikten sonra Drawer menü den de geri yüklenebilmesi sağlandı.
- Veriler silindikten sonra uygulama tekrar çalışınca home_page içinden de yenilenebiliyor.
- Bazı kod tekrarları optimize edildi.
- Türkçe harfler ayrı dosyaya alındı. Böylece fihrist görünüm kodu kısaldı
- Fihrist görünümünde renk ve font düzenlemeleri yapıldı.
- Kelime veri tabanı yüklenirken animasyon eklendi. Dialog kutusu düzeltildi.
- Arama kutusu içinde silme eklendi. Font awesome ile ikon değiştirildi
- provider eklendi (kelime sayacı) veri silinip uygulama baştan çalışınca görülebiliyor.
- kelime sayacı animasyonlu olsun
- Kelime sayacı assets 'den de okunabilsin.
- Süre sayacı eklendi
- Yedeklerin ayrı bir dizine alınması sağlandı.
- Excel formatında da yedekleme sağlandı.
- word_database.dart dosyası db_helper.dart olarak değiştirildi.
- sql dosyası da diğer yedekler ile aynı dizine taşındı.
- words.db > kelimelik.db yapıldı
- insertWord metodu insertRecord oldu (db_helper.dart)
- updateWord metodu updateRecord oldu (db_helper.dart)
- deleteWord metodu deleteRecord oldu (db_helper.dart)
- countWords metodu countRecords oldu (db_helper.dart)
- exportWordsToJson metodu exportRecordsToJson oldu (db_helper.dart)
- importWordsFromJson metodu importRecordsFromJson oldu (db_helper.dart)
- exportWordsToCsv metodu exportRecordsToCsv oldu (db_helper.dart)
- importWordsFromCsv metodu importRecordsFromCsv oldu (db_helper.dart)
- exportWordsToExcel metodu exportRecordsToExcel oldu (db_helper.dart)
- getWords metodu getRecords oldu (db_helper.dart)
- Tüm drawer menü modüler hale geldi
- Uygulama adı format aa.vb.xxxxxxxx şeklinde değiştirildi.
- notification_service.dart kodu güncellendi.
- add_word_dialog_handler.dart dosyası show_word_dialog_handler.dart olarak değiştirildi
- showAddWordDialog metodu showWordDialogHandler olarak değiştirildi.
- Silme/ekleme/güncelleme ve kelime kontrolü uyarıları aynı yerden yapıldı.
- Yedekleme uyarısı da how_word_dialog_handler.dart dosyası içine alındı.
- Notification boyutları düzeltildi.
- JSON/CSV/Excel ve SQL backup 'ları farklı yöntem ile alınacak sözlük web app gibi alındı.
- excel_backup_helper.dart silindi.
- csv_backup_helper.dart silindi.
- json_backup_helper.dart silindi.
- Kelime silme dialog kutusu düzeltildi.
- TriggerXXX metodu backupNotificationHelper olarak değiştirildi.
- export_words.dart dosyası export_items.dart dosyası olarak değiştirildi.
- word_export_formats.dart dosyası export_items_formats.dart dosyası olarak değiştirildi.
- ExportResultX sınıfı ExportItems olarak değiştirildi.
- exportWordsToJsonCsvXlsx metodu exportItemsToFileFormats olarak değiştirildi.
- pubspec.yaml dosyası düzenlendi.
- sdk bilgisi sdk: ">=3.9.0 <4.0.0" yapıldı.
- Uygulama ikonu değiştirildi.

- Simdilik yapılanlar yeterli mi?

Yapılacaklar :
- Cihazdaki veriler ile sanal cihaz verisini güncelle

<BR>
Ekran Görüntüleri
<HR>

<BR>
<table>
  <tr>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-01.png" height="400em"/>
      <br><em>Ana ekran</em>
    </td>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-02.png" height="400em"/>
      <br><em>Arama kutusu</em>
    </td>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-03.png" height="400em"/>
      <br><em>Drawer Menu</em>
    </td>
  </tr>
<tr>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-04.png" height="400em"/>
      <br><em>Klasik görünüm</em>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-05.png" height="400em"/>
      <br><em>Yedek oluşturma</em>
    </td>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-06.png" height="400em"/>
      <br><em>Veritabanı sıfırlama</em>
    </td>
  </tr>
<tr>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-07.png" height="400em"/>
      <br><em>Silinme mesajı</em>
    </td>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-08.png" height="400em"/>
      <br><em>Boş ekran</em>
    </td>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-09.png" height="400em"/>
      <br><em>Veritabanı yenileniyor</em>
    </td>
  </tr>
<tr>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-10.png" height="400em"/>
      <br><em>Sağdan herhangi bir harfe dokununca o harf ile ilgili kelimeler geliyor</em>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-11.png" height="400em"/>
      <br><em>Kelime giriş ekranı</em>
    </td>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-12.png" height="400em"/>
      <br><em>Kelimeye uzun basılınca çıkan seçenekler</em>
    </td>
  </tr>
<tr>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-13.png" height="400em"/>
      <br><em>Kelime düzeltme ekranı</em>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-14.png" height="400em"/>
      <br><em>Kelime silme mesajı</em>
    </td>
    <td align="center" width="300px">
      <img src="https://raw.githubusercontent.com/VedatBiner/flutter-codes/master/kelimelik_words_app/screen_shots/img-15.png" height="400em"/>
      <br><em>Kelime siliniyor</em>
    </td>
  </tr>
</table>

