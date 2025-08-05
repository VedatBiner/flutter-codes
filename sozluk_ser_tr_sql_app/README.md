# sozluk_ser_tr_sql_app

Sırpça-Türkçe sözlük 
SQL lite Versiyonu 
Bu kod bir başka uygulama olan kelimelik-words-app uygulamasından 
türetilmiş ve daha geliştirilmiştir.


- Genel kod yapısı oluşturuldu
- Dosya adları ayrı bir dosya ile sabitlendi
- Sırpça sıralama metodu eklendi
- ikon değiştirildi.
- Yardım Yapısı Drawer menüye ekleniyor.
- Appbar 'a home ikon eklendi
- Firebase versiyonundaki sabit doküman buraya da aktarıldı.
- Gerekli yardımcı doküman düzenlemeleri ve menü yapısı oluşturuldu.
- Veri tabanı yenileme animasyonu eklendi
- provider paketi eklenerek AppBar 'da kelime sayısının güncel görünmesi sağlandı.
- Veri Tabanı sıfırlama yenileme bölümüne de provider eklendi
- App bar arama kutusuna kutu içine silme seçeneği eklendi
- Veri güncelleme uygulama yeniden başlatılıp, tüm veriler silinince çalışıyor?
- Verilerin harici dizine yedeklenmesi sağlandı.
- Veri tabanı sıfırlama ayrı kod olarak çıkarıldı. 
- Veri tabanı yenileme işlemine kronometre eklendi
- Verilerin Firebase 'den json olarak çekilmesi eklendi.
- Verilerin SQL ve Firebase 'den eklenmesi, güncellenmesi ve silinmesi düzeltildi.
- Bekleme ekranı eklendi.
- Word_database.dart dosyası Db_helper.dart olarak rename edildi.
- WordDatabase sınıfı DbHelper olarak rename edildi. (db_helper.dart)
- excel_backup_helper.dart dosyası eklendi.
- getWords metodu getRecords oldu (db_helper.dart)
- insertWord metodu insertRecord oldu (db_helper.dart)
- updateWord metodu updateRecord oldu (db_helper.dart)
- deleteWord metodu deleteRecord oldu (db_helper.dart)
- countWords metodu countRecords oldu (db_helper.dart)
- exportWordsToJson metodu exportRecordsToJson oldu (db_helper.dart)
- importWordsFromJson metodu importRecordsFromJson oldu (db_helper.dart)
- exportWordsToCsv metodu exportRecordsToCsv oldu (db_helper.dart)
- importWordsFromCsv metodu importRecordsFromCsv oldu (db_helper.dart)
- word_model dosyasına göre excel_backup_helper.dart dosyası düzeltildi
- sözlüğün konsola sırpça sıralı yazılması sağlandı.
- bekleme mesajı güncellendi

Yapılacak başka bir şey var mı ?

Düzeltilecekler.
- SQL verinin yedeği alınmıyor?
- Sayaç kısmını kontrol et