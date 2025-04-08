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
- Bazı kod tekrarları optimize edildi

Yapılacaklar :
- Cihazdaki veriler ile sanal cihaz verisini güncelle
- Fihrist görünümünün renkleri düzenlenecek
- Fihrist görünümü için kod değişikliği gerekebilir.
