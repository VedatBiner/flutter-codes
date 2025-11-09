# sozluk_ser_tr_web_v3_app

test amaçlı olarak Firestore üzerinde web den ve mobil 'den CRUD işlemleri yapan uygulama
1. Firestore ayarları yapıldı ve test edildi. Erişim sağlandı 
2. Firestore koleksiyonu JSON olarak web 'den indirildi. Yaklaşık 1500 KB. 
3. Firestore koleksiyonu JSON olarak mobil 'den indirildi. Yaklaşık 1500 KB. 
4. home_page.dart kodu bölünerek koda temiz bir görünüm verilecek. 
5. JSON,CSV,XLSX aktarma işlemleri web ve mobilde düzgün çalışıyor. 
6. Home Page biraz temizlendi.flutter
7. Yedekleme seçeneği drawer menüye eklendi.
8. Home page geri dönüş butonu eklendi.
9. Firebase servisleri için word_service.dart dosyası düzenleniyor.
10. Buton stilleri için button_constants.dart dosyası eklendi.
11. buton ikon görselleri eklendi. 
12. Ekleme ve Aynı kelime kontrolü çalışıyor. 
13. Arama kutusu da açılır kapanır hale geldi. 
14. Ufak bir liste görünümü getirilerek aranan kelimeler görülebiliyor. 
15. Kelimeler Card içine alındı, silme düzeltme butonları eklendi. 
16. Arama hem sırpça hem de Türkçe yapılıyor 
17. Bildirim kutusunun boyutu değiştirilip, gölge verildi. 
18. Uygulama görünür adı ve ikonları değiştirildi. 
19. Alt bölümde verilen mesajlar için ayrı metod oluşturulup, farklı yerlerden ortak kullanım sağlandı. 
20. Sayfa görünümü düzeltildi. 
21. Body görünümü düzenlendi. 
22. Kelime düzeltme ve silme kodları ayrı dosyalara alındı. 
23. Kelime silme ve düzeltme dialogları düzeltildi. 
24. Homepage  butonunun konumu düzeltildi. 
25. Düzelt ve sil kutuları düzeltildi. 
26. Güncelleme mesajı show_word_dialog_handler.dart dosyasına alındı. 
27. Yedekleme mesajı show_word_dialog_handler.dart dosyasına alındı. 
28. notification kutularının boyutları düzeltildi. 
29. AppBar mobil cihaz başlığı düzeltildi. 
30. sdk: ">=3.9.0 <4.0.0" olarak değiştirildi. 
31. Versiyon bilgisine © 2025 eklendi. - 17.10.2025 
32. file_info.dart dosyası düzeltildi. - 20.10.2025 
33. word_card.dart dosyası import satırları düzeltildi. - 20.10.2025 
34. pageSize değerleri 500 yapıldı. - 21.10.2025 
35. json_saver_io.dart dosyasında konsol log 'ları düzeltildi. - 21.10.2025 
36. export_words.dart dosyası export_items.dart olarak değiştirildi. - 21.10.2025 
37. word_export_formats.dart dosyası export_items_formats.dart olarak değiştirildi. - 21.10.2025 
38. main.dart konsol log 'ları düzeltildi. - 21.10.2025 
39. backup_notification_helper.dart dosyasında konsol log 'ları düzeltildi. - 21.10.2025 
40. showBackupExportNotification metodu showBackupNotification olarak değiştirildi. - 21.10.2025 
41. show_word_dialog_handler.dart konsol log 'ları düzeltildi. - 22.10.2025
42. `show_word_dialog_handler.dart` dosyası `show_notifications_handler.dart` olarak değiştirildi. - 25.10.1025
43. `word_action_buttons.dart` dosyası `item_action_buttons.dart` olarak değiştirildi. - 25.10.2025
44. `word_dialog.dart` dosyası `item_dialog.dart` olarak değiştirildi. - 25.10.2025
45. `word_model.dart` dosyası `item_model.dart` olarak değiştirildi. - 25.10.2025
46. `word_list_view.dart` dosyası `item_list_view.dart` olarak değiştirildi. - 25.10.2025
47. `word_card.dart` dosyası `item_card.dart` olarak değiştirildi. - 25.10.2025
48. `word_service.dart` dosyası `item_service.dart` olarak değiştirildi. - 25.10.2025
49. `edit_word_dialog.dart` dosyası `edit_item_dialog.dart` olarak değiştirildi. - 25.10.2025
50. `delete_word_dialog.dart` dosyası `delete_item_dialog.dart` olarak değiştirildi. - 25.10.2025 
51. dosya adları da olabildiğince standartlaştırıldı. - 25.10.2025 
52. log etiketleri tag değişkenine atanıp, okunurluk sağlandı. - 04.11.2025
53. `main.dart`, `item_service.dart`, `json_saver_io.dart`, `show_notifications|handler.dart`, `export_item.dart` ve `backup_notification_helper.dart` dosyalarında log bilgileri düzeltildi. - 04.11.2025
54. `drawer_title.dart`dosyasında başlık düzeltmesi yapıldı. - 04.11.2025
55. `drawer_share_tile.dart`  ve `share_helper.dart` dosyası eklendi. - 04.11.2025 
56. `json_saver_io.dart` dosyası düzeltildi. - 05.11.2025
57. `text_constants.dart` dosyasına `drawerMenuSubtitleText` sabiti eklendi. 05.11.2025
58. `drawer_backup_tile.dart` ve `drawer_share_tile.dart` dosyasında düzeltme yapıldı. - 05.11.2025
59. drawer menüye veri dışarı gönderme seçeneği eklendi. Bu seçenek mobilde çalışıyor. - 05.11.2025
60. `backup_notification_helper.dart`dosyasında bir kaç ufak yazım düzeltmesi yapıldı. - 07.11.2025
61. Bildirimlerin aşağı alınması için `notification_service.dart`  dosyasında `Alignment position = Alignment.Center` değeri `Alignment position = Alignment.bottomCenter`ve uyumlu olarak
    `AnimationType animation = AnimationType.fromBottom`  yapıldı. - 09.11.2025
62. `showWordDialogHandler` metodu `showNotificationsHandler` olarak değiştirildi. - 09.11.2025
63. `showEditWordDialogHandler` metodu `showEditItemDialogHandler` olarak değiştirildi. - 09.11.2025
64. `showDeleteWordHandler` metodu `showDeleteItemHandler` olarak değiştirildi. - 09.11.2025
65. `WordDialog` metodu `ItemDialog` olarak değiştirildi. - 09.11.2025







Yapılacaklar : 
- Alfabetik görünümü sağlanması. Özellikle arama işleminde gerekebilir.
- mobilde açılış çok uzun sürüyor.
- yedekleri paylaş adımı Web 'de çalışmıyor ? bu hata çıkıyor : Paylaşım hatası: MissingPluginException(No implementation found for method getExternalStoragePublicDirectory on channel external_path)
- web de yedekleri zip haline getirip, download dizinine indirip, manuel paylaşma yoluna gidilecek.
- 
- 
