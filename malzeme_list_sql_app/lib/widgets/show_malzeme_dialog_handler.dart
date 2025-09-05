// 📃 <----- add_malzeme_dialog_handler.dart ----->
//
// eski add_word_dialog_handler
// Malzeme varsa mesaj verip uyarıyor
// Malzeme yoksa listeye ekliyor.

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/malzeme_model.dart';
import '../services/notification_service.dart';
import 'malzeme_dialog.dart';

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
    final existing = await DbHelper.instance.getWord(result.malzeme);

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
              TextSpan(
                text: result.malzeme,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.orange,
                ),
              ),
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
    );
  }
}

/// 🔔 Yedek oluşturuldu bildirimi (JSON/CSV/Excel yollarını kısa adla gösterir)
void showBackupResultNotification({
  required BuildContext rootCtx, // root navigator context
  required String jsonPathInApp,
  required String csvPathInApp,
  required String excelPathInApp,
  required String jsonPathDownload,
  required String csvPathDownload,
  required String excelPathDownload,
  double width = 280,
  double height = 260,
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
            const TextSpan(text: 'Uygulama içi :\n', style: kelimeAddText),
            TextSpan(text: p.basename(jsonPathInApp)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(csvPathInApp)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(excelPathInApp)),
            const TextSpan(text: '  •  '),

            const TextSpan(text: '\n\nDownloads :\n', style: kelimeAddText),
            TextSpan(text: p.basename(jsonPathDownload)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(csvPathDownload)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(excelPathDownload)),
            const TextSpan(text: '  •  '),
          ],
        ),
      ),
      icon: Icons.download_for_offline_outlined,
      iconColor: Colors.green,
      progressIndicatorColor: Colors.green,
      progressIndicatorBackground: Colors.greenAccent.shade100,
      width: width,
      height: height,
    );
  });
}

/// ✅ Malzeme güncelleme bildirimi (tek satırdan çağrılır)
void showMalzemeUpdatedNotification({
  required BuildContext context,
  required String malzemeAdi,
  IconData icon = Icons.check_circle,
  Color color = Colors.green,
  double? width,
  double? height,
}) {
  NotificationService.showCustomNotification(
    context: context,
    title: 'Malzeme Güncellendi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: malzemeAdi, style: kelimeAddText),
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
    width: width, // istersen dışarıdan geçebilirsin
    height: height, // istersen dışarıdan geçebilirsin
  );
}
