// 📃 <----- lib/widgets/show_notification_handler.dart ----->


import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../constants/text_constants.dart';
import '../services/notification_service.dart';

/// 📌 Yedekleme bildirim gösterir
///
void showBackupNotification(
    BuildContext rootCtx,
    // String sqlPathDownload,
    String csvPathDownload,
    String jsonPathDownload,
    String excelPathDownload,
    // String zipPathDownload,
    ) {
  return NotificationService.showCustomNotification(
    context: rootCtx,
    title: ' ',
    message: RichText(
      text: TextSpan(
        style: normalBlackText,
        children: [
          const TextSpan(
            text: '\nVeriler yedeklendi ... \n\n',
            style: kelimeAddText,
          ),
          // const TextSpan(text: '✅ '),
          //  TextSpan(text: "${p.basename(sqlPathDownload)}\n"),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(csvPathDownload)}\n"),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(jsonPathDownload)}\n"),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(excelPathDownload)}\n"),
        ],
      ),
    ),
    icon: Icons.download_for_offline_outlined,
    iconColor: Colors.green,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade100,
    width: 320,
    height: 200,
  );
}

void showShareFilesNotification(BuildContext rootCtx) {
  return NotificationService.showCustomNotification(
    context: rootCtx,
    title: ' ',
    message: RichText(
      text: const TextSpan(
        style: normalBlackText,
        children: [
          TextSpan(
            text: '\nDosyalar paylaşılmıştır ... \n\n',
            style: kelimeAddText,
          ),
        ],
      ),
    ),
    icon: Icons.download_for_offline_outlined,
    iconColor: Colors.green,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade100,
    width: 260,
    height: 200,
  );
}

// void showCreateDbNotification(
//     BuildContext rootCtx,
//     // String sqlPathDownload,
//     String csvPathDownload,
//     String jsonPathDownload,
//     String excelPathDownload,
//     // String zipPathDownload,
//     ) {
//   logCreate(
//     // sqlPathDownload,
//     csvPathDownload,
//     jsonPathDownload,
//     excelPathDownload,
//   );
//   return NotificationService.showCustomNotification(
//     context: rootCtx,
//     title: ' ',
//     message: RichText(
//       text: TextSpan(
//         style: normalBlackText,
//         children: [
//           const TextSpan(text: '\nVeriler yüklendi\n\n', style: kelimeAddText),
//           // const TextSpan(text: '✅ '),
//           // TextSpan(text: "${p.basename(sqlPathDownload)}\n"),
//           const TextSpan(text: '✅ '),
//           TextSpan(text: "${p.basename(csvPathDownload)}\n"),
//           const TextSpan(text: '✅ '),
//           TextSpan(text: "${p.basename(jsonPathDownload)}\n"),
//           const TextSpan(text: '✅ '),
//           TextSpan(text: "${p.basename(excelPathDownload)}\n"),
//         ],
//       ),
//     ),
//     icon: Icons.download_for_offline_outlined,
//     iconColor: Colors.green,
//     progressIndicatorColor: Colors.green,
//     progressIndicatorBackground: Colors.green.shade100,
//     width: 300,
//     height: 220,
//   );
// }

// void logCreate(
//     String csvPathDownload,
//     String jsonPathDownload,
//     xlsxPathDownload,
//     // sqlPathDownload,
//     ) {
//   log(logLine, name: tag);
//   log("✅ CSV oluşturuldu: $csvPathDownload", name: tag);
//   log("✅ JSON oluşturuldu: $jsonPathDownload", name: tag);
//   log("✅ XLSX oluşturuldu: $xlsxPathDownload", name: tag);
//   // log("✅ SQL oluşturuldu: $sqlPathDownload", name: tag);
//   log(logLine, name: tag);
//}