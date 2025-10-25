// 📃 <----- item_actions.dart ----->
//
// Kelime kartı üzerinde ortak kullanılan "Düzenle" ve "Sil" eylemleri.
// Bu dosyada sadece EYLEM mantığı bulunur. Bildirim fonksiyonları
// (showUpdateNotification, showDeleteNotification) artık
// show_notification_handler.dart dosyasına taşındı.
//
// Not: Bu dosyadaki açıklamalar özellikle KORUNMUŞTUR.
//

// Flutter
import 'package:flutter/material.dart';

// Proje içi bağımlılıklar
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';
import 'confirmation_dialog.dart';
import 'item_dialog.dart';
import 'show_notification_handler.dart'; // bildirimleri çağırmak için

// --- KULLANIM ÖNERİSİ ---------------------------------------------------------
// WordCard üzerinde uzun basınca açılan eylem menüsünden bu fonksiyonlar çağrılır.
//
//   onEdit:  () => editWord(context, word, onUpdated: _refreshList),
//   onDelete:() => confirmDelete(context, word, onDeleted: _refreshList),
// -----------------------------------------------------------------------------

/// Kelime düzenleme akışı.
///
/// - WordDialog’u açar, kullanıcı değişiklikleri kaydederse DB 'de günceller.
/// - Başarılı güncellemede `onUpdated()` (varsa) çağrılır.
/// - Bildirim gösterimi `show_notification_handler.dart` içindeki
///   `showUpdateNotification(...)` ile yapılır.
Future<void> editWord({
  required BuildContext context,
  required Word word,
  VoidCallback? onUpdated,
}) async {
  // 1) Dialog 'u aç
  final updated = await showDialog<Word>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => WordDialog(word: word),
  );

  // 2) Kullanıcı iptal ettiyse çık
  if (updated == null) return;

  // 3) DB 'de güncelle
  try {
    // Projende DbHelper.updateRecord / updateWord isimlerinden biri olabilir.
    // Ekleme tarafında insertRecord kullandığın için burada updateRecord tercih edildi.
    await DbHelper.instance.updateRecord(updated);

    // 4) UI 'ı yenile
    onUpdated?.call();

    // 5) Bildirim
    if (context.mounted) {
      showUpdateNotification(context, updated);
    }
  } catch (e) {
    if (!context.mounted) return;
    // Hata olduğunda basit bir uyarı
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Güncelleme başarısız: $e')));
  }
}

/// Silme onayı akışı.
///
/// - Kullanıcıdan onay alır.
/// - Onay verilirse veritabanından kelimeyi siler.
/// - Başarılı silmede `onDeleted()` (varsa) çağrılır.
/// - Bildirim gösterimi `show_notification_handler.dart` içindeki
///   `showDeleteNotification(...)` ile yapılır.
Future<void> confirmDelete({
  required BuildContext context,
  required Word word,
  required VoidCallback onDeleted,
}) async {
  final confirm = await showConfirmationDialog(
    context: context,
    title: 'Kelime Silme Onayı',
    content: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: word.word, style: kelimeText),
          const TextSpan(
            text: ' kelimesini silmek istiyor musunuz?',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    ),
    confirmText: 'Sil',
    cancelText: 'İptal',
    confirmColor: deleteButtonColor,
  );

  if (confirm != true) return;

  try {
    // Projende deleteRecord / deleteWord isimlerinden biri olabilir.
    // Ekleme tarafında insertRecord kullandığın için burada deleteRecord tercih edildi.
    await DbHelper.instance.deleteRecord(word.id!);

    // UI yenile
    onDeleted.call();

    // Bildirim
    if (context.mounted) {
      showDeleteNotification(context, word);
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Silme başarısız: $e')));
  }
}
