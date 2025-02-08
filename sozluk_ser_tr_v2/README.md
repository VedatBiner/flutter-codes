# sozluk_ser_tr_ui

Sırpça-Türkçe ve diğer benzer uygulamalar için
Sadece sabitler ve ara yüz tasarımı

Karşılaşılan hatalar 
1. Card ve List Görünümünde Türkçe-Sırpça bölümünde Türkçe kelimeye göre sıralama hatalı. 
    Burada hep Sırpça kelimeye göre sıralama oluyor ?
2. Card ve List Görünümünde Türkçe-Sırpça bölümünde "Ve son tarih" kelimesi en başta geliyor
3. Dil değişip Türkçe-Sırpça olunca Türkçe-Sırpça text kutuları ters bilgiler alıyor. Bu durum
edit ve delete adımlarını da etkiliyor. Düzeltilmesi gerek.
4. arama sadece ilk başa göre çalışıyor. Ortadaki veya sondaki arama yapılmıyor ?
5. bazı aramalarda kelimeler iki kez tekrarlanıyor.
6. kelime varsa kelime var mesajı ve arkasından kelimeeklendi mesajı çıkıyor.
7. kelime düzeltildikten sonra sayfa güncellenmiyor. Eski bilgi kalıyor.

Yapılan Düzeltmeler 
1. Boş mail adreslerini düzeltme işlemi settings_page.dart dosyasına eklendi.
2. Kelime ekleme ve düzeltme bölümlerinde farklı dialog kutuları çıkarılması sağlandı.
3. Eklenen kelimeler artık mail adresi ile birlikte ekleniyor. Boş mail adresi kelime sayısı çok aza indirgendi.
4. Kelime ekleme kutusu düzeltildi.
5. *** İPTAL *** Kelime silme ve ekleme aynı snackbar ile kullanılır hale getirildi.
6. Uygulama adı ve ikonları değiştirildi.
7. Silme işlemi gerçekleşti. Şimdilik kontrol yok. Önce silip silemeyeceği kontrol edilip, sonra silmesi sağlanacak.
8. Kelime düzeltme (güncelleme) kutusu kodu çalıştı. 
9. Bu hali ile firebase web host olarak düzenleyelim. 
10. Details bölümüne kelimeler liste olarak aktarıldı. Artık burası Firebase Firestore 'dan bağımsız çalışıyor.
11. Details bölümünde önceki ve sonraki kayıtlara geçiş işlemi liste üzerinden yapılıyor.
12. Details bölümündeki kelimeler arası geçişler OK butonları veya slider ile yapılabiliyor
13. mail adresi eklenemeyen kayıtlara elle ekleyebilecek bir ekran düzenleyelim.
14. Firstore verisini bir kez okuyp liste veya json üzerinden aram yapılsın. 
15. Bu duruma göre sadece ekleme, silme ve değişiklik halinde önce kliste güncellenip, sonra fire store 'a yazılsın.'
16. Eğer Web erişimli girerse firestore 'doğrudan yazma ve düzeltme olsun, aksi halde liste yapısı kullanılsın.'
17. ekleme, düzeltme ve silem işlemlerinde alttaki mesajların kütüphanesi değiştirildi. elegant_notification paketi kullanılıyor.
18. flutter_toast kütüphanesi kaldırıldı.
19. kelime varsa mesaj çıkmasında bir problem var. Aynı andaa var ve eklenid mesajı çıkıyor
20. snacbar_helper.dart dosyası silindi.
21. notificatio_service.dart dosyası ile tüm notificasyonlar tek fonksiyon ile çalışır hale geldi.

