// <📜 ----- lib/handlers/show_word_dialog_handler.dart ----->

/*
  📦 show_word_dialog_handler.dart — Dialog akışlarını yöneten “handler” katmanı

  🧩 Ne yapar?
  - ✅ Yeni kelime ekleme akışını yönetir (showWordDialogHandler):
      • WordDialog açar, form sonucunu alır
      • Kelime zaten varsa uyarı bildirimi gösterir
      • Yoksa WordService.addWord ile kaydeder ve başarı bildirimi gösterir
      • onWordAdded() callback ’i ile üst bileşeni tetikler (listeyi tazele vb.)
  - ✏️ Var olan kelimeyi düzenleme (showEditWordDialogHandler):
      • editWordDialog’u açar (görsel tema unified)
      • Güncelleme başarılıysa yeşil başarı bildirimi gösterir
  - 🗑️ Silme akışı (showDeleteWordHandler):
      • deleteWordDialog ile “emin misiniz?” onayını alır, siler, refetch eder
      • Başarılıysa kırmızı silme bildirimi gösterir
  - 💾 Yedek/Export başarı bildirimi (showBackupExportNotification):
      • triggerBackupExport içindeki onSuccessNotify callback ’i tarafından çağrılır
      • JSON/CSV/XLSX çıktı yollarını ve toplam kayıt sayısını detaylı bir bildirimde gösterir

  🧷 Bağımlılıklar
  - NotificationService  → özel bildirim kartları
  - WordService          → Firestore CRUD
  - WordDialog / editWordDialog / deleteWordDialog → UI dialogları
  - ExportResultX        → export sonuç tipi (JSON/CSV/XLSX yolları ve sayaç)

  🔁 Dönüşler (özet)
  - showWordDialogHandler(...)          → Future<void>
  - showEditWordDialogHandler(...)      → Future<void>
  - showDeleteWordHandler(...)          → Future<bool> (silindiyse true)
  - showBackupExportNotification(...)   → void (sadece bildirim)

  🧪 Kullanım (örnek)
    // 1) Ekleme
    await showWordDialogHandler(context, () {
      // ekleme sonrası yapılacaklar (listeyi tazele vb.)
    });

    // 2) Düzenleme
    await showEditWordDialogHandler(
      context,
      word: existingWord,
      onRefetch: () async { /* listeyi yeniden yükle */ },
    );

    // 3) Silme
    final ok = await showDeleteWordHandler(
      context: context,
      word: existingWord,
      onRefetch: () async { /* listeyi yeniden yükle */ },
    );

    // 4) Export (başarı bildirimi handler ’dan)
    await triggerBackupExport(
      context: context,
      onStatusChange: (s) { /* UI durum metni */ },
      onExportingChange: (v) { /* loading flag */ },
      onSuccessNotify: showBackupExportNotification, // ← önemli
      pageSize: 1000,
      subfolder: appName,
    );

  📝 Notlar
  - Bildirimlerin hepsi NotificationService üzerinden tek elden verilir.
  - Dialogların kendi içinde servis çağrısı yapanları (ör. editWordDialog)
  sonuçlarını bu handler değerlendirir ve uygun bildirimi tetikler.

  - Export bildirimini helper yerine buraya taşıyarak, uygulama genelinde
  bildirim stilini konsolide etmiş olursun.

*/

// 📌 Dart paketleri burada
import 'dart:developer';

/// 📌 Flutter paketleri burada
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';
import '../models/word_model.dart';
import '../services/export_items.dart' show ExportResultX;
import '../services/notification_service.dart';
import '../services/word_service.dart';
import '../widgets/body_widgets/delete_word_dialog.dart';
import '../widgets/body_widgets/edit_word_dialog.dart';
import '../widgets/word_dialog.dart';

/// ADD: Yeni kelime ekleme diyaloğu
Future<void> showWordDialogHandler(
  BuildContext context,
  VoidCallback onWordAdded,
) async {
  final result = await showDialog<Word>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const WordDialog(),
  );

  if (result != null) {
    /// ❓Kelime varsa bildirim göster
    final exists = await WordService.wordExists(result.sirpca);
    if (exists) {
      if (!context.mounted) return;
      NotificationService.showCustomNotification(
        context: context,
        title: 'Uyarı Mesajı',
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: result.sirpca, style: kelimeExistText),
              const TextSpan(text: ' zaten var!', style: normalBlackText),
            ],
          ),
        ),
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
        progressIndicatorColor: Colors.orange,
        progressIndicatorBackground: Colors.orange.shade100,
      );
      return;
    }

    /// 📌 Kelime yoksa ekle
    await WordService.addWord(result);
    log('Kelime eklendi: ${result.sirpca}', name: 'ADD_WORD');

    onWordAdded();
    if (!context.mounted) return;

    NotificationService.showCustomNotification(
      context: context,
      title: 'Kelime Ekleme İşlemi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: result.sirpca, style: kelimeAddText),
            const TextSpan(text: ' kelimesi eklendi.', style: normalBlackText),
          ],
        ),
      ),
      icon: Icons.check_circle,
      iconColor: Colors.blue.shade700,
      progressIndicatorColor: Colors.blue,
      progressIndicatorBackground: Colors.blue.shade200,
      height: 140,
      width: 300,
    );
  }
}

/// 📌 Var olan kelimeyi güncelle
Future<void> showEditWordDialogHandler(
  BuildContext context, {
  required Word word,
  required Future<void> Function() onRefetch,
}) async {
  final ok = await editWordDialog(
    context: context,
    word: word,
    onRefetch: onRefetch, // güncelleme ve refetch içeride
  );

  if (!context.mounted || !ok) return;

  // ✅ Bildirim burada
  NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Güncelleme İşlemi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: word.sirpca, style: kelimeUpdateText),
          const TextSpan(
            text: ' kelimesi güncellenmiştir',
            style: normalBlackText,
          ),
        ],
      ),
    ),
    icon: Icons.check_circle,
    iconColor: Colors.green.shade700,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade200,
    height: 140,
    width: 300,
  );
}

/// 📌 Silme akışını yönetir:
/// - deleteWordDialog ile onay alır + siler + refetch eder
/// - başarılıysa burada bildirimi gösterir
Future<bool> showDeleteWordHandler({
  required BuildContext context,
  required Word word,
  required Future<void> Function() onRefetch,
}) async {
  final deleted = await deleteWordDialog(
    context: context,
    word: word,
    onRefetch: onRefetch,
  );

  if (!deleted || !context.mounted) return false;

  // 🔔 Bildirimi burada
  NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Silme İşlemi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: word.sirpca, style: kelimeDeleteText),
          const TextSpan(text: ' Kelimesi silinmiştir', style: normalBlackText),
        ],
      ),
    ),
    icon: Icons.delete,
    iconColor: Colors.red.shade700,
    progressIndicatorColor: Colors.red,
    progressIndicatorBackground: Colors.red.shade200,
    height: 140,
    width: 300,
  );

  return true;
}

/// ✅ BACKUP başarı bildirimi artık burada (helper, callback ile burayı çağırır)
void showBackupNotification(BuildContext context, ExportResultX res) {
  NotificationService.showCustomNotification(
    context: context,
    title: 'Yedek Oluşturuldu',
    message: RichText(
      text: TextSpan(
        style: normalBlackText,
        children: [
          const TextSpan(text: "\nVeriler yedeklendi\n", style: kelimeAddText),
          const TextSpan(
            text: "Toplam Kayıt sayısı:\n",
            style: notificationTitle,
          ),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${res.count}\n", style: notificationText),
          const TextSpan(text: '\nDownload :\n', style: kelimeAddText),
          const TextSpan(text: '✅ '),
          const TextSpan(text: "JSON yedeği →\n", style: notificationItem),
          TextSpan(text: "${res.jsonPath}\n", style: notificationText),
          const TextSpan(text: '✅ '),
          const TextSpan(text: "CSV yedeği →\n", style: notificationItem),
          TextSpan(text: "${res.csvPath}\n", style: notificationText),
          const TextSpan(text: '✅ '),
          const TextSpan(text: "XLSX yedeği →\n", style: notificationItem),
          TextSpan(text: "${res.xlsxPath}\n", style: notificationText),
        ],
      ),
    ),
    icon: Icons.download_for_offline_outlined,
    iconColor: Colors.green,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.greenAccent.shade100,
    height: 340,
    width: 360,
  );
}
