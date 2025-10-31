// 📃 <----- show_notifications_handler.dart ----->
//
// Malzeme varsa mesaj verip uyarıyor
// Malzeme yoksa listeye ekliyor.

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../services/notification_service.dart';
import 'item_dialog.dart';

Future<void> showAddMalzemeDialog(
  BuildContext context,
  VoidCallback onMalzemeAdded,
  VoidCallback onCancelSearch, // arama kutusunu kapatmak için
) async {
  onCancelSearch(); // arama kutusunu kapat

  final result = await showDialog<Malzeme>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const MalzemeDialog(),
  );

  if (result != null) {
    final existing = await DbHelper.instance.getItem(result.malzeme);

    if (existing != null) {
      /// ✅ Eğer malzeme zaten varsa: Uyarı bildirimi göster
      if (!context.mounted) return;

      /// 📌 Notification göster - Malzeme var
      ///
      NotificationService.showCustomNotification(
        context: context,
        title: 'Uyarı Mesajı',
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: result.malzeme, style: kelimeExistText),
              const TextSpan(text: ' zaten var!', style: normalBlackText),
            ],
          ),
        ),
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
        progressIndicatorColor: Colors.orange,
        progressIndicatorBackground: Colors.orange.shade100,
        width: 260,
        height: 240,
      );
      return;
    }

    await DbHelper.instance.insertRecord(result);
    onMalzemeAdded();

    /// ✅ Başarılı ekleme bildirimi göster
    if (!context.mounted) return;

    /// 📌 Notification göster - Malzeme eklendi
    ///
    NotificationService.showCustomNotification(
      context: context,
      title: 'Malzeme Ekleme İşlemi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: result.malzeme, style: kelimeAddText),
            const TextSpan(text: ' malzemesi eklendi.', style: normalBlackText),
          ],
        ),
      ),
      icon: Icons.check_circle,
      iconColor: Colors.blue.shade700,
      progressIndicatorColor: Colors.blue,
      progressIndicatorBackground: Colors.blue.shade200,
      width: 260,
      height: 240,
    );
  }
}

/// 🔔 Yedek oluşturuldu bildirimi (JSON/CSV/Excel yollarını kısa adla gösterir)
void showBackupNotification({
  required BuildContext rootCtx, // root navigator context
  required String jsonPathDownload,
  required String csvPathDownload,
  required String excelPathDownload,
  required String sqlPathDownload,
}) {
  // Bildirimi frame tamamlandıktan sonra göstermek için
  WidgetsBinding.instance.addPostFrameCallback((_) {
    NotificationService.showCustomNotification(
      context: rootCtx,
      title: 'Yedek Oluşturuldu',
      message: RichText(
        text: TextSpan(
          style: normalBlackText,
          children: [
            const TextSpan(text: '\nDownload :\n', style: kelimeAddText),
            const TextSpan(text: '✅ '),
            TextSpan(text: "${p.basename(jsonPathDownload)}\n"),
            const TextSpan(text: '✅ '),
            TextSpan(text: "${p.basename(csvPathDownload)}\n"),
            const TextSpan(text: '✅ '),
            TextSpan(text: "${p.basename(excelPathDownload)}\n"),
            const TextSpan(text: '✅ '),
            TextSpan(text: "${p.basename(sqlPathDownload)}\n"),
          ],
        ),
      ),
      icon: Icons.download_for_offline_outlined,
      iconColor: Colors.green,
      progressIndicatorColor: Colors.green,
      progressIndicatorBackground: Colors.greenAccent.shade100,
      width: 260,
      height: 240,
    );
  });
}

/// ✅ Malzeme güncelleme bildirimi (tek satırdan çağrılır)
void showMalzemeUpdatedNotification({
  required BuildContext context,
  required String malzemeAdi,
  IconData icon = Icons.check_circle,
  Color color = Colors.green,
}) {
  NotificationService.showCustomNotification(
    context: context,
    title: 'Malzeme Güncellendi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: malzemeAdi, style: kelimeUpdateText),
          const TextSpan(
            text: ' malzemesi güncellendi.',
            style: normalBlackText,
          ),
        ],
      ),
    ),
    icon: icon,
    iconColor: color,
    progressIndicatorColor: color,
    progressIndicatorBackground: color.withOpacity(0.15),
    width: 260,
    height: 200,
  );
}

/// 🗑️ Malzeme silindi bildirimi (senin orijinal ayarlarınla)
void showMalzemeDeletedNotification({
  required BuildContext context,
  required String malzemeAdi,
  IconData icon = Icons.delete,
  Color color = Colors.red,
}) {
  NotificationService.showCustomNotification(
    context: context,
    title: 'Malzeme Silindi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: malzemeAdi, style: kelimeText),
          const TextSpan(text: ' malzemesi silindi.', style: normalBlackText),
        ],
      ),
    ),
    icon: icon,
    iconColor: color,
    progressIndicatorColor: color,
    progressIndicatorBackground: Colors.red.shade100,
    width: 260,
    height: 200,
  );
}
