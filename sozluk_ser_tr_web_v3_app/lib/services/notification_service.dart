// © Vedat Biner / 📃 notification_service.dart

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class NotificationService {
  static void showCustomNotification({
    required BuildContext context,
    required String title,
    required Widget message,
    IconData icon = Icons.check_circle,
    Color iconColor = Colors.blue,
    Alignment position = Alignment.bottomCenter,
    AnimationType animation = AnimationType.fromBottom,
    required Color progressIndicatorBackground,
    required Color progressIndicatorColor,

    // ⬇️ Yeni: opsiyonel override
    double? width,
    double? height,
    Duration duration = const Duration(seconds: 6),
  }) {
    // Ekran boyutuna göre makul ölçüler (override edilebilir)
    final size = MediaQuery.sizeOf(context);
    double w =
        width ??
        (size.width >= 1024
            ? size.width *
                  0.28 // desktop
            : size.width >= 600
            ? size.width *
                  0.60 // tablet
            : size.width *
                  0.92 // phone
                  );
    double h = height ?? (size.height * 0.22);

    // Aşırı sapmaları engelle
    w = w.clamp(280.0, 560.0);
    h = h.clamp(160.0, 400.0);

    // // Eski bildirimleri kapat (üst üste binmesin)
    // ElegantNotification.dismissAll(context);

    ElegantNotification(
      background: notificationColor,
      width: w,
      height: h,
      stackedOptions: StackedOptions(
        key: 'center',
        type: StackedType.same,
        scaleFactor: 0.2,
        itemOffset: const Offset(-20, 10),
      ),
      toastDuration: duration,
      position: position,
      animation: animation,
      title: Text(title),
      description: message,
      progressBarHeight: 10,
      progressBarPadding: const EdgeInsets.symmetric(horizontal: 20),
      showProgressIndicator: true,
      progressIndicatorColor: progressIndicatorColor,
      progressIndicatorBackground: progressIndicatorBackground,
      icon: Icon(icon, color: iconColor),
      shadow: const BoxShadow(
        color: Colors.black38,
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 4),
      ),
    ).show(context);
  }
}
