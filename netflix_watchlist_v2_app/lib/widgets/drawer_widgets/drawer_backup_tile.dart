// 📃 <----- lib/widgets/drawer_widgets/drawer_backup_tile.dart ----->
//
// ============================================================================
// 💾 DrawerBackupTile – “Yedek Oluştur” Menü Öğesi
// ============================================================================
//
// Bu dosya Drawer menüsündeki “Yedek Oluştur” satırını tek başına yöneten,
// yeniden kullanılabilir bir widget içerir.
//
// Amaç:
// - custom_drawer.dart dosyasını sadeleştirmek (kod tekrarını azaltmak)
// - Yedekleme (export) akışını tek bir noktadan tetiklemek
// - Export tamamlanınca kullanıcıya bildirim (notification) göstermek
//
// ----------------------------------------------------------------------------
// 🔹 Kullanıcı Akışı
// ----------------------------------------------------------------------------
// 1) Kullanıcı Drawer ’da “Yedek Oluştur” satırına dokunur.
// 2) backupNotificationHelper(...) çağrılır.
//    - Export sürecini başlatır (CSV / JSON / XLSX üretimi)
//    - Gerekirse alt bant (loading banner) gösterir
//    - İş bitince export path ’lerini geri döndürür
// 3) Export tamamlanınca showBackupNotification(...) çağrılır.
//    - Kullanıcıya hangi dosyaların üretildiğini ve path ’lerini gösterir
// 4) Drawer kapatılır (Navigator.of(context).maybePop())
//
// ----------------------------------------------------------------------------
// 🔹 Bağımlılıklar
// ----------------------------------------------------------------------------
// - color_constants.dart   → ikon rengi vb.
// - text_constants.dart    → drawer yazı stilleri
// - backup_notification_helper.dart → export akışını başlatır ve yönetir
// - show_notification_handler.dart  → kullanıcıya bildirim gösterir
//
// ============================================================================

import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../utils/backup_notification_helper.dart';
import '../show_notification_handler.dart';

class DrawerBackupTile extends StatelessWidget {
  const DrawerBackupTile({super.key});

  /// ==========================================================================
  /// 🏗 build
  /// ==========================================================================
  /// Drawer içinde görünen ListTile’ı üretir:
  /// - leading: download ikonu
  /// - title/subtitle: kullanıcıya açıklama
  /// - onTap: yedekleme akışını başlatır
  ///
  /// Bu widget stateless ’tir; çünkü state yönetimi (yükleniyor vb.)
  /// backupNotificationHelper tarafında yapılır.
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'JSON/CSV/XLSX\nyedeği oluştur',
      child: ListTile(
        leading: Icon(Icons.download, color: downLoadButtonColor, size: 32),
        title: Text('Yedek Oluştur', style: drawerMenuText),
        subtitle: Text(
          "Aşağıdaki formatlarda \nyedek oluşturur: \n(JSON / CSV / XLSX)",
          style: drawerMenuSubtitleText,
        ),
        // ------------------------------------------------------------
        // ▶️ Kullanıcı dokununca export akışı başlar
        // ------------------------------------------------------------
        onTap: () async {
          /// ==========================================================
          /// 🚀 backupNotificationHelper çağrısı
          /// ==========================================================
          /// Bu helper:
          /// - Export sürecini başlatır
          /// - UI ’da “yükleniyor” banner gösterebilir
          /// - İş tamamlanınca onSuccessNotify ile ExportItems döndürür
          ///
          /// Buradaki callback ’ler:
          /// - onStatusChange: export aşamalarını UI ’ya iletmek için (şimdilik boş)
          /// - onExportingChange: export başladı/bitti bilgisini UI ’ya iletmek için (şimdilik boş)
          /// - onSuccessNotify: export bitince notification basmak için kullanıyoruz
          /// ==========================================================
          await backupNotificationHelper(
            context: context,
            // Bu projede şimdilik dışarıya status basmıyoruz.
            onStatusChange: (_) {},
            // Bu projede şimdilik dışarıya status basmıyoruz.
            onExportingChange: (_) {},
            // Export tamamlanınca kullanıcıya dosya bilgilerini göster
            onSuccessNotify: (ctx, res) {
              /// --------------------------------------------------------
              /// ✅ showBackupNotification
              /// --------------------------------------------------------
              /// res içinde Download klasöründeki kesin path ’ler bulunur.
              /// Kullanıcıya hangi dosyaların üretildiğini göstermek için
              /// notification basıyoruz.
              ///
              /// DİKKAT: Parametre sırası doğru olmalı:
              /// showBackupNotification(ctx, csvPath, jsonPath, excelPath)
              /// --------------------------------------------------------
              showBackupNotification(
                ctx,
                res.csvPath,
                res.jsonPath,
                res.excelPath,
              );
            },
          );

          /// ==========================================================
          /// 🧭 Drawer kapatma (güvenli)
          /// ==========================================================
          /// Export uzun sürebilir; işlem bitince context hâlâ geçerli mi
          /// kontrol ediyoruz. Sonra Drawer ’ı kapatmayı deniyoruz.
          /// maybePop(): Eğer Navigator stack ’inde pop yapılabilecek bir şey yoksa
          /// patlamadan “false” döner.
          /// ==========================================================
          if (!context.mounted) return;
          Navigator.of(context).maybePop();
        },
      ),
    );
  }
}
