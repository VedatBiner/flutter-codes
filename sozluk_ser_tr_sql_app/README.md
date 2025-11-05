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
- Drawer menüdeki yardımcı kavramlar modüler hale getirildi
- Tüm drawer menü modüler hale geldi
- uygulama adı standart formata geldi
- pubspec.yaml düzeltilip, standart haline getirildi. - 17.10.2025
- Versiyon bilgisine yıl (© 2025) eklendi. - 17.10.2025
- excel_backup_helper.dart silindi. - 18.10.2025
- csv_backup_helper.dart silindi. - 18.10.2025
- json_backup_helper.dart silindi. - 18.10.2025
- loading_bottom_banner.dart eklendi. - 18.10.2025
- json_saver.dart eklendi. - 18.10.2025
- json_saver_io.dart eklendi. - 18.10.2025
- db_helper.dart düzeltildi. - 18.10.2025
- notification_service.dart services dizinine taşındı. - 18.10.2025
- file_info.dart dosyasında filenameExcel ifadesi fileNameXlsx olarak değiştirildi. - 18.10.2025
- add_word_dialog_handler.dart dosyası show_word_dialog_handler.dart olarak değiştirildi. - 18.10.2025
- showAddWordDialog metodu showBackupNotification olarak değiştirildi. - 18.10.2025
- kelimeExistText sabiti eklendi. - 18.10.2025
- `notification_service.dart` dosyası güncellendi. - 18.10.2025
- `custom_fab.dart` dosyası düzeltildi. - 18.10.2025
- Kotlin versiyonu 2.1.0 yapıldı. (settings.gradle.kts) - 18.10.2025
- String subfolder = 'sozluk_ser_tr_sql_app' böyle yapıldı. - 18.10.2025
- `file_info.dart` içinde final olan değerler const olarak değiştirildi. - 19.10.2025
- `page_***.dart` şekilindeki yardım dosyalarında import ifadelirinde bazı satırlar düzeltildi. - 19.10.2025
- isolate yapısı deneniyor. - 20.10.2025
-  `show_word_dialog_handler.dart` dosyası `show_notifications_handler.dart` olarak değiştirildi. - 25.10.1025
72. `show_notifications_handler.dart` bildirim görünümü düzeltildi. - 25.10.2025
73. `word_action_buttons.dart` dosyası `item_action_buttons.dart` olarak değiştirildi. - 25.10.2025
74. `word_dialog.dart` dosyası `item_dialog.dart` olarak değiştirildi. - 25.10.2025
75. `word_model.dart` dosyası `item_model.dart` olarak değiştirildi. - 25.10.2025
76. `word_count_provider.dart` dosyası `item_count_provider.dart` olarak değiştirildi. - 25.10.2025
76. `word_actions.dart` dosyası `item_actions.dart` olarak değiştirildi. - 25.10.2025
77. `word_card.dart` dosyası `item_card.dart` olarak değiştirildi. - 25.10.2025
78. `word_count_provider.dart` dosyası `item_count_provider.dart` olarak değiştirildi. - 25.10.2025
79. `alphabet_word_list.dart` dosyası `alphabet_item_list.dart` olarak değiştirildi. - 25.10.2025
80. `word_list.dart` dosyası `item_list.dart` olarak değiştirildi. - 25.10.2025
81. `word_service.dart` dosyası `item_service.dart` olarak değiştirildi. - 25.10.2025
82. dosya adları da olabildiğince standartlaştırıldı. - 25.10.2025
83. `json_loader.dart` dosyasındaki hatalar düzeltildi.
84. `pubspec.yaml`dosyası assets bölümü düzeltildi. - 25.10.2025
85. Veri tabanı yenileme ve veri tabanı silme seçenekleri `custom_drawer.dart` kodundan geçici olarak iptal edildi. - 31.10.2025
85. `file_info.dart` dosyası yenilendi. `sqlTableName` değişkeni eklendi. - 31.10.2025
86. `db_helper.dart` dosyası `sqlTableName` değişkenine göre düzenlendi. - 31.10.2025
87. `getWord` metodu `getItem` olarak değiştirildi. - 31.10.2025
88. log etiketleri `tag` değişkenine atanıp, okunurluk sağlandı. - 05.11.2025 
89. `json_saver_io.dart`, `export_items.dart` ve `backup_notification_helper.dart`, `storge_permission_helper.dart`, ve `db_helper.dart` dosyalarında log bilgileri düzeltildi. - 05.11.2025
90. `drawer_title.dart`dosyasında başlık düzeltmesi yapıldı. - 04.11.2025
91. 


Yapılacak başka bir şey var mı ?
- Dışarı aktarma ve Excel 'e dönüştürme işlemlerini Kelimelik ve malzemelik ile aynı yapıya getirelim.
- Eğer düzgün çalışırsa diğer uygulamalardaki file_info.drt dosyasını da aynı formata getirelim.
- Düzeltme işleminde bildirim çalışmıyor ?
- kaydetme işleminde bildirim çalışmıyor ?
- Excel dosya formatı düzgün mü ?
- Veri tabanı yenileme bölümünde hata var gibi ?
- 
