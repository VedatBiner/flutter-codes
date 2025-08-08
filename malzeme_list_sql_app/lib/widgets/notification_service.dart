// 📃 <----- notification_service.dart ----->
//
// Uygulama genelinde kullanıcıya mesaj/bilgi göstermek için kullanılan
// merkezi bildirim servisidir.
//
// • `showSuccess`, `showWarning`, `showError` gibi metodlarla özel temalı
//    bildirimler gösterilir.
// • ElegantNotification gibi görsel zenginleştirme sunan yapı ile entegredir.
// • Snack bar yerine daha şık ve dikkat çekici uyarılar için tercih edilir.
// • Özellikle kelime ekleme, veri silme, dışa aktarma gibi işlemler sonrası kullanılır.
//
// Kullanıldığı yerler:
//   • add_word_dialog.dart → Kelime eklendiğinde
//   • drawer_backup_tile.dart → Yedekleme sonrası
//   • drawer_reset_db_tile.dart → Veritabanı sıfırlama sonrası

// 📌 Flutter paketleri
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';

class NotificationService {
  static void showCustomNotification({
    required BuildContext context,
    required String title,
    required Widget message,
    IconData icon = Icons.check_circle,
    Color iconColor = Colors.blue,
    Alignment position = Alignment.centerLeft,
    AnimationType animation = AnimationType.fromLeft,
    required Color progressIndicatorBackground,
    required Color progressIndicatorColor,
  }) {
    ElegantNotification(
      background: notificationColor,
      width: 280,
      height: 240,
      stackedOptions: StackedOptions(
        key: 'left',
        type: StackedType.same,
        scaleFactor: 0.2,
        itemOffset: const Offset(-20, 10),
      ),
      toastDuration: const Duration(seconds: 6),
      position: position,
      animation: animation,
      title: Text(title),
      description: message,
      progressBarHeight: 10,
      progressBarPadding: const EdgeInsets.symmetric(horizontal: 20),
      onNotificationPressed: () {},
      showProgressIndicator: true,
      progressIndicatorColor: progressIndicatorColor,
      progressIndicatorBackground: progressIndicatorBackground,
      icon: Icon(icon, color: iconColor),
    ).show(context);
  }
}
