// 📃 <----- database_reset_helper.dart ----->
//
// Veritabanını tamamen temizlemek için ortak fonksiyon.
// İstediğiniz widget’tan ‟await showResetDatabaseDialog(context, onAfterReset);”
// şeklinde çağırabilirsiniz.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../db/word_database.dart';
import '../providers/word_count_provider.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/notification_service.dart';

/// 📌 Veritabanını tamamen silmek için onay kutusu
/// Tüm kelimeleri siler ve kullanıcıya ElegantNotification gösterir.
///
/// * [context]         – Diyaloğu gösterecek context
/// * [onAfterReset]    – İşlem başarıyla bittikten sonra (örn. UI yenilemek için)
Future<void> showResetDatabaseDialog(
  BuildContext context, {
  required VoidCallback onAfterReset,
}) async {
  final confirm = await showConfirmationDialog(
    context: context,
    title: 'Veritabanını Sıfırla',
    content: const Text(
      'Tüm kelimeler silinecek. Emin misiniz?',
      style: kelimeText,
    ),
    confirmText: 'Sil',
    cancelText: 'İptal',
    confirmColor: deleteButtonColor,
    cancelColor: cancelButtonColor,
  );

  if (confirm != true) return;

  // 🔥 Tablodaki tüm verileri sil
  final db = await WordDatabase.instance.database;
  await db.delete('words');

  if (!context.mounted) return;

  // Provider’daki sayaç sıfırlansın
  Provider.of<WordCountProvider>(context, listen: false).setCount(0);

  // Drawer kapalıysa MediaQuery garantili kök context
  final rootCtx = Navigator.of(context, rootNavigator: true).context;

  NotificationService.showCustomNotification(
    context: rootCtx,
    title: 'Veritabanı Sıfırlandı',
    message: const Text('Tüm kayıtlar silindi.'),
    icon: Icons.delete_forever,
    iconColor: Colors.red,
    progressIndicatorColor: Colors.red,
    progressIndicatorBackground: Colors.red.shade100,
  );

  onAfterReset();
}
