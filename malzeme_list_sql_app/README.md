# malzeme_list_sql_app

Eksik malzeme listesini tutan uygulama.
kelimelik_words_app temel alınarak yapılmıştır.

- Yapı oluşturuldu. Uygulama ikonları eklendi.
- Açıklama girilecek satır eklendi
- Kaydırmalı arttırma / eksiltme düğmesi eklendi.
- Arttırma eksiltme işlemi provider ile kontrol ediliyor.
- Kaydırma için flutter_slidable paketi eklendi.
- Türkçe sıralama ile ilgili sorun giderildi.
- MalzemeDatabase DbHelper olarak değiştirildi.
- Excel yedek alma eklendi.
- insertWord metodu insertRecord oldu (db_helper.dart)
- updateWord metodu updateRecord oldu (db_helper.dart)
- deleteWord metodu deleteRecord oldu (db_helper.dart)
- countWords metodu countRecords oldu (db_helper.dart)
- exportWordsToJson metodu exportRecordsToJson oldu (db_helper.dart)
- exportWordsToCsv metodu exportRecordsToCsv oldu (db_helper.dart)
- getWords metodu getRecords oldu (db_helper.dart)
- Tüm drawer menü modüler hale geldi

- Hatalar :
  - Veriler önce json yedeğinden yükleniyor. bu durumda json sorunlu ise veri gelmiyor.
  - Veri eklenince listenin sonuna gidiyor ? Yani baş harfi ile başlayan bölümün sonuna ekleniyor. Uygun harf sırasına gelmiyor ?

