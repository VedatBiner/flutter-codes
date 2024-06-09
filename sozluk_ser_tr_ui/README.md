# sozluk_ser_tr_ui

Sırpça-Türkçe ve diğer benzer uygulamalar için
Sadece sabitler ve ara yüz tasarımı

Karşılaşılan hatalar 
1. Card ve List Görünümünde Türkçe-Sırpça bölümünde Türkçe kelimeye göre sıralama hatalı. 
    Burada hep Sırpça kelimeye göre sıralama oluyor ?
2. Card ve List Görünümünde Türkçe-Sırpça bölümünde "Ve son tarih" kelimesi en başta geliyor
3. Boş mail adreslerini düzeltme işlemi settings_page.dart dosyasına eklendi.
4. Kelime ekleme ve düzeltme bölümlerinde farklı dialog kutuları çıkarılması sağlandı. 
 Ancak kelime seçimine göre sıralama da hatalar var.
5. Eklenen kelimeler artık mail adresi ile birlikte ekleniyor. Boş mail adresi kelime sayısı çok aza indirgendi.
6. Kelime ekleme kutusu ile kelime eklenmesi. Türkçe-Sırpça durumunda kelime görünümü Sırpça üstte, Türkçe altta oluyor. Tam tersi olmalı
7. Kelime silme ve ekleme aynı snackbar ile kullanılır hale getirildi.
8. Kelime silme de kontrol ve silme işlemi tam gerçekleşmiyor. Önce silip silemeyeceği kontrol edilip, sonra silmesi sağlanacak.
9. Kelime düzeltme kutusu düzenlenecek