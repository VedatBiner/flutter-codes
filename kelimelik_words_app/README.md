# kelimelik_words_app

Kelimelik oyunu için basit bir sqflite uygulaması
bir chatGPT ortak çalışması :)

1. SQfLite ile veri girişi yapılıyor. 
2. Girilen verilerin yedekleri SQL, JSON ve CSV olarak alınabiliyor.
3. Kelime ekleme, silme, güncelleme kontrolü var.
4. Aynı kelime tekrar girilemiyor.
5. Versiyon bilgisi var.
6. Drawer menu ayrı dosyaya alındı
7. Home_page daha sadeleşti
8. Kelime kartına iki kez tıklanınca düzeltme ve silme butonları çıkıyor.
9. Kart görünümü renklendirildi.
10. Kelime eklemeye notification eklendi
11. Kelime silmeye notification eklendi
12. Kelime güncellemeye notification eklendi
13. Kelime ekleme kutusu açılınca arama kutusu kapatılıyor.
14. Biraz renklendirme yapıldı.
15. Butonlar renklendirildi.
16. Sık kullanılan renk ve stiller sabit dosyalara alındı. Böylece renk değişimi tek yerden yapılabilecek.
17. Türkçe sıralama yapıldı.
18. Bazı notification hataları düzeltildi.
19. Veri tabanı silme dialog kutusu düzeltildi
20. Uygulama ikonu değiştirildi.
21. Uygulama adı değiştirildi
22. Fihrist ve klasik liste görünümü eklendi.
23. iki kod da da tekrarlanan kelime silme dialog bölümü tek kod ile ortak kullanılır hale getirildi.
24. veritabanı silme dialog box 'da önceki dialog ile birleştirilip, üç ayrı kodun aynı ortak dialog kutusunu kullanması sağlandı.
25. Arama kutusu ikonları görselleştirildi.
26. Silme ve düzenleme ikonları değiştirildi.
27. FAB butonu biraz sola çekildi.
28. Silme ve düzenleme ortak butonları tek dosyaya ayrıldı.
29. JSON ve CSV yedek alma işlemi iki ayrı dosyaya ayrılıp, tek menü seçeneğine indirildi.
30. Verilerin SQL 'den silinip, JSON ile yeniden yüklenmesi sağlandı.
31. Verilerin silindikten sonra Drawer menü den de geri yüklenebilmesi sağlandı.
32. Veriler silindikten sonra uygulama tekrar çalışınca home_page içinden de yenilenebiliyor.
33. Bazı kod tekrarları optimize edildi.
34. Türkçe harfler ayrı dosyaya alındı. Böylece fihrist görünüm kodu kısaldı
35. Fihrist görünümünde renk ve font düzenlemeleri yapıldı.
36. Kelime veri tabanı yüklenirken animasyon eklendi. Dialog kutusu düzeltildi.
37. Arama kutusu içinde silme eklendi. Font awesome ile ikon değiştirildi
38. provider eklendi (kelime sayacı) veri silinip uygulama baştan çalışınca görülebiliyor.
39. kelime sayacı animasyonlu olsun
40. Kelime sayacı assets 'den de okunabilsin.
41. Süre sayacı eklendi
42. Yedeklerin ayrı bir dizine alınması sağlandı.
43. Excel formatında da yedekleme sağlandı.
44. `word_database.dart` dosyası `db_helper.dart` olarak değiştirildi.
45. sql dosyası da diğer yedekler ile aynı dizine taşındı.
46. words.db > kelimelik.db yapıldı
47. insertWord metodu insertRecord oldu (db_helper.dart)
48. updateWord metodu updateRecord oldu (db_helper.dart)
49. deleteWord metodu deleteRecord oldu (db_helper.dart)
50. countWords metodu countRecords oldu (db_helper.dart)
51. `exportWordsToJson` metodu `exportRecordsToJson` oldu (db_helper.dart)
52. `importWordsFromJson` metodu `importRecordsFromJson` oldu (db_helper.dart)
53. `exportWordsToCsv` metodu `exportRecordsToCsv` oldu (db_helper.dart)
54. `importWordsFromCsv` metodu `importRecordsFromCsv` oldu (db_helper.dart)
55. `exportWordsToExcel` metodu `exportRecordsToExcel` oldu (db_helper.dart)
56. `getWords` metodu `getRecords` oldu (db_helper.dart)
57. Tüm drawer menü modüler hale geldi
58. Uygulama adı formatı `aa.vb.xxxxxxxx` şeklinde değiştirildi.
59. `notification_service.dart` kodu güncellendi.
60. `add_word_dialog_handler.dart` dosyası show_word_dialog_handler.dart olarak değiştirildi
61. `showAddWordDialog` metodu `showWordDialogHandler` olarak değiştirildi.
62. Silme/ekleme/güncelleme ve kelime kontrolü uyarıları aynı yerden yapıldı.
63. Yedekleme uyarısı da `show_word_dialog_handler.dart` dosyası içine alındı.
64. Notification boyutları düzeltildi.
65. JSON/CSV/Excel ve SQL backup 'ları farklı yöntem ile alınacak sözlük web app gibi alındı.
66. `excel_backup_helper.dart` silindi.
67. `csv_backup_helper.dart` silindi.
68. `json_backup_helper.dart` silindi. 
69. Kelime silme dialog kutusu düzeltildi.
70. `TriggerXXX` metodu `backupNotificationHelper` olarak değiştirildi.
71. `export_words.dart` dosyası `export_items.dart`  dosyası olarak değiştirildi.
72. `word_export_formats.dart` dosyası `export_items_formats.dart` dosyası olarak değiştirildi.
73. `ExportResultX` sınıfı `ExportItems` olarak değiştirildi.
74. `exportWordsToJsonCsvXlsx` metodu `exportItemsToFileFormats` olarak değiştirildi.
75. `pubspec.yaml` dosyası düzenlendi. 
76. sdk bilgisi sdk: `>=3.9.0 <4.0.0` yapıldı. 
77. Uygulama ikonu değiştirildi. 
78. `© 2025` bilgisi eklendi
79. `file_info.dart` dosyasında final değerler const olarak değiştirildi. - 20.10.2025 
80. bu değişiklikle ilgili olan `backup_notification_helper.dart` ve `export_items.dart` dosyaları da güncellendi. -20.10.2025 
81. Konsola yazılan log bilgileri düzeltildi. - 20.10.2025
82. `show_word_dialog_handler.dart` dosyası `show_notifications_handler.dart` olarak değiştirildi. - 25.10.1025
83. `show_notifications_handler.dart` bildirim görünümü düzeltildi. - 25.10.2025
84. `word_action_buttons.dart` dosyası `item_action_buttons.dart` olarak değiştirildi. - 25.10.2025
85. `word_dialog.dart` dosyası `item_dialog.dart` olarak değiştirildi. - 25.10.2025
86. `word_model.dart` dosyası `item_model.dart` olarak değiştirildi. - 25.10.2025
87. `word_actions.dart` dosyası `item_actions.dart` olarak değiştirildi. - 25.10.2025
88. `word_card.dart` dosyası `item_card.dart` olarak değiştirildi. - 25.10.2025
89. `word_count_provider.dart` dosyası `item_count_provider.dart` olarak değiştirildi. - 25.10.2025
90. `alphabet_word_list.dart` dosyası `alphabet_item_list.dart` olarak değiştirildi. - 25.10.2025
91. `word_list.dart` dosyası `item_list.dart` olarak değiştirildi. - 25.10.2025 
92. dosya adları da olabildiğince standartlaştırıldı. - 25.10.2025
93. `settings.gradle.kts` dosyası düzenlendi. - 25.10.2025 
94. Veri tabanı yenileme ve veri tabanı silme seçenekleri `custom_drawer.dart`kodundan geçici olarak iptal edildi. - 31.10.2025
95. `file_info.dart` dosyası yenilendi. `sqlTableName`değişkeni eklendi. - 31.10.2025
96. `db_lhelper.dart` dosyası `sqlTableName`değişkenine göre düzenlendi. - 31.10.2025
97. `export_items.dart` dosyasında düzeltme yapıldı. - 31.10.2025
98. `getWord` metodu `getItem` olarak değiştirildi. - 31.10.2025
99. log etiketleri tag değişkenine atanıp, okunurluk sağlandı. - 04.11.2025
100. `drawer_share_tile.dart` ve `share_helper.dart` dosyası eklendi. - 04.11.2025
101. drawer menüye veri dışarı gönderme seçeneği eklendi. - 04.11.2025
102. `drawer_backup_tile.dart` ve `drawer_share_tile.dart` dosyasınde düzeltme yapıldı. - 04.11.2025
103. `text_constants.dart.` dosyasına `drawerMenuSubtitleText` sabiti eklendi. - 04.11.2025
104. `drawer_title.dart`dosyasında başlık düzeltmesi yapıldı. - 04.11.2025
105. NDK güncellemesi yapıldı. (manuel) - 04.11.2025
106. `device_info_plus` paketi eklendi. - 15.11.2025
107. `device_info_helper.dart` dosyası eklendi. - 15.11.2025
108. `home_page.dart` dosyası düzenlendi. - 15.11.2025
109. `file_cretor.dart`ve `zip_helper.dart` dosyası eklendi. - 21.11.2025
110. bu dosyalarda şimdilik sadece .zip yedeği alınması işlemi yapılacak. - 21.11.2025
111. `archive` paketi eklendi. - 21.11.2025
112. `file_info.dart` dosyasına zip dosya adı eklendi. - 21.11.2025
113. `AndroidManifest.xml` dosyası güncellendi. - 21.11.2025
114. `storage_permission_handler.dart` dosyası güncellendi. - 21.11.2025
115. `download_directory_helper.dart` dosyası eklendi. - 21.11.2025
116. `home_page.dart` dosyası düzenlendi. - 21.11.2025
117. `csv` paketi eklendi. - 22.11.2025
118. `csv_helper.dart` ve `json_helper.dart` dosyaları eklendi. - 22.11.2025
119. `excel_helper.dart` ve `sql_helper.dart` dosyası eklendi. - 22.11.2025
120. `db_helper.dart` dosyası güncellendi. - 22.11.2025
121. `csv_parser.dart`dosyası eklendi. - 22.11.2025
122. `home_page.dart`, `file_creator.dart`, `zip_helper.dart`, `drawer_backup_tile.dart` ve `export_items.dart` dosyası tekrar düzenlendi. - 22.11.2025
123. `csv_helper.dart`, `json_helper.dart`, `excel_helper.dart`, `sql_helper.dart` ve `file_creator.dart` dosyaları yenilendi. - 23.11.2025
124. `zip_helper.dart`, `file_creator.dart`, `backup_notification.helper.dart` ve `home_page.dart` düzenlendi. zip dosya oluşuyor ve konsola log 'lanıyor. - 25.11.2025
125. logLine değişkeni ie log 'larda sabit çizgi çizilmesi sağlandı. - 25.11.2025
126. `file_creator.drt`, `csv_helper.dart` ve `db_helper.dart`dosyaları güncellendi. - 26.11.2025
127. `show_notifications_handler.dart` dosyası güncellendi. - 26.11.2025
128. veriler oluşunca notification verilmesi sağlandı. - 27.11.2025
129. `csv_helper.dart` dosyası güncellendi - 27.11.2025
130. Raporlama işi için `fc_report.dart` dosyası oluşturuldu. - 27.11.2025
131. Detaylı raporlama yaptırıldı. - 28.11.2025
132. `sql_helper.dart` dosyası güncellendi. - 29.11.2025
133. `zip_helper.dart` dosyası güncellendi. - 29.11.2025
134. `zip_helper.dart` dosyası `fc_files` dizinine kopyalandı. - 29.11.2025
135. `assets\animations\fileupload.json` dosyası kaldırıldı. - 29.11.2025
136. eski `export_items.dart`, `export_items_formats.dart`, `json_loader.dart`, `json_loader_io.dart` ve `sql_loading_card.dart` dosyaları kaldırıldı. - 29.11.2025
137. `loading_bottombanner.dart` dosyasının adı `bottom_banner_helper.dart` olarak değiştirildi. - 01.12.2025
138. `bottom_banner_helper.dart` dosyası düzenlendi. - 01.12.2025
139. yedekler dışarı ile paylaşılınca da notification veriyor. - 02.12.2025
140. `ìtem_card.dart`, `home_page.dart`, `alphabet_item_list.dart` ve `ìtem_list` dosyalarında performans düzeltmeleri yapıldı. - 03.12.2025
141. `custom_app_bar.drt` dosyası da düzenlendi. - 03.12.2025
142. `ìtem_dialog.dart` klavye hatasına karşı düzeltildi. - 04.12.2025
143. `safe_text_field.dart` dosyası klavye güvenliği için yeni eklendi. - 04.12.2025
144. `custom_app_bar.drt` dosyası da güvenli düzeltildi. - 04.12.2025
145. `safe_keyboard.dart` dosyası eklendi - 04.12.2025
146. `zip_helper.dart`, `backup_notification_helper.dart`, `file_exporter.dart` ve `file_creator.dart` dosyaları güncellendi. - 05.12.2025
147. `export_items.dart` dosyası eklendi. - 05.12.2025
148. `share_helper.dart`dosyası güncellendi. - 05.12.2025
149. `excel_helper.dart`dosyası güncellendi. - 06.12.2025
150. `drawer_backup_tile.dart` dosyası düzeltildi. 06.12.2025
151. `custom_app_bar.drt` dosyası düzeltildi. - 07.12.2025
152. Geçici olarak Normal Görünüm seçeneği iptal edildi. - 08.12.2025
153. `custom_drawer.dart` ve `home_page.dart` dosyaları güncellendi. 152. adıma göre - 08.12.2025
154. `sync_helper.dart` dosyası eklenerek hatalı veri kaybı düzeltildi. - 08.12.2025
155. `fc_report.dart` ve `alphabet_item_list.dart` dosyası güncellendi. - 08.12.2025
156. `safe_text_field.dart` dosyası düzeltildi. - 08.12.2025
157. text kutularının renkleri ve alfabetik seçimde harf boyutu düzeltildi. - 08.12.2025
158. `external_copy.dart` dosyası ile download dizinine kopyalama yapılacak. - 08.12.2025
159. `drawer_bakup_tile.dart` dosyası düzeltildi. - 08.12.2025
160. `excel_helper.dart`, `external_copy.dart`, `file_exporter.dart` ve `file_creator.dart` dosyaları güncellendi. - 09.12.2025
161. `db_helper.dart` dosyası düzenlendi. - 09.12.2025
162. `excel_helper.dart`, `file_creator.dart` ve `show_notification_handler.dart` dosyaları güncellendi. - 10.12.2025
163. `excel_helper.dart` dosyası güncellendi. - 11.12.2025
164. Excel dosyasındaki auto filter sorunu giderildi. - 11.12.2025
165. `file_creator.dart` dosyasında artık zip işlemi yok. - 12.12.2025
166. `show_notification_handler.dart` dosyası düzenlendi. - 12.12.2025
167. `custom_drawer.dart` dosyası güncellendi. - 12.12.2025
168. `file_creator.dart` dosyası excel format sorunu düzeltildi. - 13.12.2025
169. `excel_helper.dart` dosyası düzeltildi. - 13.12.2025
170. `file_infoe.dart` dosyasına `backupDirName` eklendi. - 13.12.2025
171. `drawer_backup_tile.dart` ve `file_creator.dart` dosyası düzenlendi. - 14.12.2025
172. `file_creator.dart`, `export_items.dart` ve `backup_notification_helper.dart` dosyası düzenlendi. - 14.12.2025
173. `export_items.dart`, `external_copy.dart` ve `backup_notification_helper.dart` dosyası güncellendi. - 15.12.2025
174. `show_notification_handler.dart` güncellendi. - 15.12.2025
175. `ìtem_model.dart`, `excel_helper.dart` ve `db_helper.dart` dosyası güncellendi. - 15.12.2025
176. sql veri tabanına 3. sütun olarak veri ekleme tarihi eklenmesi deneniyor. - 15.12.2025
177. `CSV_helper.dart` dosyası güncellenerek tarih sütunu eklendi. - 16.12.2025
178. `db_helper.dart`,`json_helper.dart` ve `export_items.dart` dosyası güncellendi. - 16.12.2025
179.  `CSV_helper.dart` ve `sync_helper.dart` dosyası güncellendi. - 17.12.2025
180. yeni girilen kayıtta bugünün tarihi girilmesi sağlandı. - 17.12.2025
181. `file_exporter.dart`iptal edildi. - 17.12.2025
182. Zip işleri iptal `zip_helper.dart` silindi. - 18.12.2025
183. `ìtem_dialog.dart` ve `custom_app_bar.dart` dosyaları düzenlendi. - 18.12.2025
184. İstatistikler için `word_statsPage.dart`, `drawer_stats_tile.dart` dosyaları oluşturuldu. - 19.12.2025
185. `custom_drawer.dart`dosyası güncellendi. - 19.12.2025










- Simdilik yapılanlar yeterli mi?

Yapılacaklar :
- Cihazdaki veriler ile sanal cihaz verisini güncelle. Sanal cihazda /dat/data/aa.vb.kelimelik_words_app/app_flutter/kelimelik.db dosyasını silip, çalıştırınca veriler güncelleniyor.
- compute yapısı ile performans artışı sağlanabilir.
- Hatalar : 
    
    - arama ve ekleme bölümünde klavye yavaş ve kesikli geliyor. Performans iyileştirme yapıldı ama ?




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

