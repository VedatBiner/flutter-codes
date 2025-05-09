/// <----- notification_service.dart ----->
///
/// Bu kod ile ekleme, değiştirme, silme ve
/// kelime daha önceden varsa gerekli mesajların
/// gösterilmesi sağlanıyor
///
library;

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static void showCustomNotification({
    required BuildContext context,
    required String title,
    required Widget message,
    IconData icon = Icons.info_outline,
    Color iconColor = Colors.amber,
    Alignment position = Alignment.centerLeft,
    AnimationType animation = AnimationType.fromLeft,
    Color? progressIndicatorBackground,
    Color? progressIndicatorColor,
  }) {
    ElegantNotification(
      // width: 360,
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
      progressBarPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      onNotificationPressed: () {},
      showProgressIndicator: true,
      progressIndicatorColor: progressIndicatorColor!,
      progressIndicatorBackground: progressIndicatorBackground!,
      icon: Icon(icon, color: iconColor),
    ).show(context);
  }
}
