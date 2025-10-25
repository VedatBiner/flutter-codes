# sozluk_ser_tr_web_v3_app

test amaçlı olarak Firestore üzerinde web den ve mobil 'den CRUD işlemleri yapan uygulama
- Firestore ayarları yapıldı ve test edildi. Erişim sağlandı
- Firestore koleksiyonu JSON olarak web 'den indirildi. Yaklaşık 1500 KB.
- Firestore koleksiyonu JSON olarak mobil 'den indirildi. Yaklaşık 1500 KB.
- home_page.dart kodu bölünerek koda temiz bir görünüm verilecek.
- JSON,CSV,XLSX aktarma işlemleri web ve mobilde düzgün çalışıyor.
- Home Page biraz temizlendi.flutter
- Yedekleme seçeneği drawer menüye eklendi.
- Home page geri dönüş butonu eklendi.
- Firebase servisleri için word_service.dart dosyası düzenleniyor.
- Buton stilleri için button_constants.dart dosyası eklendi.
- buton ikon görselleri eklendi.
- Ekleme ve Aynı kelime kontrolü çalışıyor.
- Arama kutusu da açılır kapanır hale geldi.
- Ufak bir liste görünümü getirilerek aranan kelimeler görülebiliyor.
- Kelimeler Card içine alındı, silme düzeltme butonları eklendi.
- Arama hem sırpça hem de Türkçe yapılıyor
- Bildirim kutusunun boyutu değiştirilip, gölge verildi.
- Uygulama görünür adı ve ikonları değiştirildi.
- Alt bölümde verilen mesajlar için ayrı metod oluşturulup, farklı yerlerden ortak kullanım sağlandı.
- Sayfa görünümü düzeltildi.
- Body görünümü düzenlendi.
- Kelime düzeltme ve silme kodları ayrı dosyalara alındı.
- Kelime silme ve düzeltme dialogları düzeltildi.
- Homepage  butonunun konumu düzeltildi.
- Düzelt ve sil kutuları düzeltildi.
- Güncelleme mesajı show_word_dialog_handler.dart dosyasına alındı.
- Yedekleme mesajı show_word_dialog_handler.dart dosyasına alındı.
- notification kutularının boyutları düzeltildi.
- AppBar mobil cihaz başlığı düzeltildi.
- sdk: ">=3.9.0 <4.0.0" olarak değiştirildi.
- Versiyon bilgisine © 2025 eklendi. - 17.10.2025
- file_info.dart dosyası düzeltildi. - 20.10.2025
- word_card.dart dosyası import satırları düzeltildi. - 20.10.2025
- pageSize değerleri 500 yapıldı. - 21.10.2025
- json_saver_io.dart dosyasında konsol log 'ları düzeltildi. - 21.10.2025
- export_words.dart dosyası export_items.dart olarak değiştirildi. - 21.10.2025
- word_export_formats.dart dosyası export_items_formats.dart olarak değiştirildi. - 21.10.2025
- main.dart konsol log 'ları düzeltildi. - 21.10.2025
- backup_notification_helper.dart dosyasında konsol log 'ları düzeltildi. - 21.10.2025
- showBackupExportNotification metodu showBackupNotification olarak değiştirildi. - 21.10.2025
- show_word_dialog_handler.dart konsol log 'ları düzeltildi. - 22.10.2025
  `show_word_dialog_handler.dart` dosyası `show_notifications_handler.dart` olarak değiştirildi. - 25.10.1025
73. `word_action_buttons.dart` dosyası `item_action_buttons.dart` olarak değiştirildi. - 25.10.2025
74. `word_dialog.dart` dosyası `item_dialog.dart` olarak değiştirildi. - 25.10.2025
75. `word_model.dart` dosyası `item_model.dart` olarak değiştirildi. - 25.10.2025
76. `word_list_view.dart` dosyası `item_list_view.dart` olarak değiştirildi. - 25.10.2025
77. `word_card.dart` dosyası `item_card.dart` olarak değiştirildi. - 25.10.2025
78. `word_service.dart` dosyası `item_service.dart` olarak değiştirildi. - 25.10.2025
79. `edit_word_dialog.dart` dosyası `edit_item_dialog.dart` olarak değiştirildi. - 25.10.2025
80. `delete_word_dialog.dart` dosyası `delete_item_dialog.dart` olarak değiştirildi. - 25.10.2025
81. dosya adları da olabildiğince standartlaştırıldı. - 25.10.2025




Yapılacaklar : 
- Alfabetik görünümü sağlanması. Özellikle aram işleminde gerekebilir.
