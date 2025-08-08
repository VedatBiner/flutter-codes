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
  - Veriler yeniden yüklenirken animasyon çıkıyor ancak sayaç değişmedi ?
  - Veriler önce json yedeğinden yükleniyor. bu durumda json sorunlu ise veri gelmiyor.
  - Veriler silinince yeniden yüklenirken animasyon düzeldi ancak sayaç değişmiyor

Veri tabanı yenileyen eski modül bu : 

/// 📌 Veritabanını Yenile
ListTile(
leading: const Icon(Icons.refresh, color: Colors.amber),
title: const Text(
'Veritabanını Yenile (SQL)',
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
onTap: () async {
Navigator.of(context).maybePop();
await Future.delayed(const Duration(milliseconds: 300));
if (!context.mounted) return;

                /// ✅ Overlay erişimi düzeltildi
                final overlay = Navigator.of(context).overlay;
                final overlayEntry = OverlayEntry(
                  builder: (context) => const SQLLoadingCardOverlay(),
                );
                overlay?.insert(overlayEntry);

                /// 🔄 Veritabanını JSON 'dan yeniden yükle ve kartı güncelle
                await onLoadJsonData(
                  ctx: context,
                  onStatus: (loading, progress, currentWord, elapsed) {
                    SQLLoadingCardOverlay.update(
                      progress: progress,
                      loadingWord: currentWord,
                      elapsedTime: elapsed,
                      show: loading,
                    );

                    if (!loading) {
                      overlayEntry.remove(); // işlem bitince kartı kaldır
                    }
                  },
                );
              },
            ),
