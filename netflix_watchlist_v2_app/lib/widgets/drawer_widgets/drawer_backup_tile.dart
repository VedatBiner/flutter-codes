// 📃 <----- lib/widgets/drawer_widgets/drawer_backup_tile.dart ----->
//
// ============================================================================
// 💾 DrawerBackupTile – “Yedek Oluştur” Menü Öğesi
// ============================================================================
//
// Bu widget, Drawer menüsü içinde yer alan “Yedek Oluştur” satırını
// tek başına yöneten yeniden kullanılabilir bir bileşendir.
//
// ---------------------------------------------------------------------------
// 🎯 Amaç
// ---------------------------------------------------------------------------
// • custom_drawer.dart dosyasını sadeleştirmek
// • Export (yedekleme) akışını tek yerden başlatmak
// • Kullanıcıya süreç boyunca ve işlem sonunda doğru geri bildirim vermek
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Rol
// ---------------------------------------------------------------------------
// Bu widget export işlemini kendisi yapmaz.
//
// Gerçek akış:
//
//   DrawerBackupTile
//        ↓
//   backupNotificationHelper()
//        ↓
//   ExportRepository
//        ↓
//   ExportFileService
//
// Yani bu widget ’ın görevi:
// • sadece kullanıcı etkileşimini almak
// • helper fonksiyonunu çağırmak
// • export sonrası notification göstermektir
//
// Böylece:
// ✅ UI ile iş mantığı ayrılır
// ✅ widget sade kalır
// ✅ export akışı tek noktadan yönetilir
//
// ---------------------------------------------------------------------------
// 📌 Kullanıcı Akışı
// ---------------------------------------------------------------------------
// 1️⃣ Kullanıcı Drawer içinde “Yedek Oluştur” satırına dokunur
// 2️⃣ backupNotificationHelper(...) çağrılır
// 3️⃣ Helper:
//     • loading banner gösterir
//     • export sürecini başlatır
//     • bitince sonucu callback ile döndürür
// 4️⃣ showBackupNotification(...) ile kullanıcıya
//    oluşturulan dosyalar gösterilir
// 5️⃣ Drawer güvenli şekilde kapatılır
//
// ============================================================================

import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../utils/backup_notification_helper.dart';
import '../show_notification_handler.dart';

/// ============================================================================
/// 💾 DrawerBackupTile
/// ============================================================================
/// Drawer menüsünde görünen “Yedek Oluştur” satırını üretir.
///
/// Stateless olarak tasarlanmıştır çünkü:
/// • kendi içinde state tutmaz
/// • export sürecinin state ’i helper/repository katmanında yönetilir
/// • bu widget yalnızca aksiyon tetikler
///
/// Bu widget ’ın görevi:
/// • ListTile UI üretmek
/// • onTap ile export helper ’ı çağırmak
/// • success sonrası notification göstermek
/// ============================================================================
class DrawerBackupTile extends StatelessWidget {
  const DrawerBackupTile({super.key});

  /// =========================================================================
  /// 🏗 build()
  /// =========================================================================
  /// Drawer içinde görünen ListTile’ı oluşturur.
  ///
  /// UI yapısı:
  /// • leading  → download ikonu
  /// • title    → “Yedek Oluştur”
  /// • subtitle → hangi formatların üretileceğini anlatan metin
  ///
  /// Davranış:
  /// • Kullanıcı satıra dokunduğunda export süreci başlar
  /// • backupNotificationHelper export akışını yürütür
  /// • İşlem başarılıysa showBackupNotification çağrılır
  /// • En son Drawer güvenli biçimde kapatılır
  ///
  /// Neden Tooltip var?
  /// • Özellikle masaüstü / web benzeri kullanımda kullanıcıya
  ///   kısa açıklama göstermek için
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'JSON/CSV/XLSX\nyedeği oluştur',
      child: ListTile(
        // --------------------------------------------------------------------
        // 🎨 Sol ikon
        // --------------------------------------------------------------------
        leading: Icon(
          Icons.download,
          color: downLoadButtonColor,
          size: 32,
        ),

        // --------------------------------------------------------------------
        // 📝 Başlık
        // --------------------------------------------------------------------
        title: Text(
          'Yedek Oluştur',
          style: drawerMenuText,
        ),

        // --------------------------------------------------------------------
        // 📝 Alt açıklama
        // --------------------------------------------------------------------
        subtitle: Text(
          "Aşağıdaki formatlarda \nyedek oluşturur: \n(JSON / CSV / XLSX)",
          style: drawerMenuSubtitleText,
        ),

        // --------------------------------------------------------------------
        // ▶️ Kullanıcı dokununca export akışı başlar
        // --------------------------------------------------------------------
        onTap: () async {
          // ==========================================================
          // 🚀 backupNotificationHelper çağrısı
          // ==========================================================
          //
          // Bu helper:
          // • loading banner gösterir
          // • ExportRepository üzerinden export işlemini başlatır
          // • işlem bitince sonucu callback ile döndürür
          // • hata olursa SnackBar gösterir
          //
          // Buradaki callback ’ler:
          // • onStatusChange:
          //   Şu anda dışarıya yazmıyoruz, ama ileride progress text göstermek
          //   istersek burada kullanabiliriz.
          //
          // • onExportingChange:
          //   Şu an kullanılmıyor. İleride bir loading state bağlamak istersek
          //   parent widget bunu dinleyebilir.
          //
          // • onSuccessNotify:
          //   Export tamamlanınca kullanıcıya özel notification gösteriyoruz.
          //
          await backupNotificationHelper(
            context: context,

            // Şimdilik dışarıya status metni basmıyoruz.
            onStatusChange: (_) {},

            // Şimdilik export başladı/bitti durumunu da dışarı bağlamıyoruz.
            onExportingChange: (_) {},

            // --------------------------------------------------------
            // ✅ Export başarılıysa kullanıcıya dosya bilgilerini göster
            // --------------------------------------------------------
            onSuccessNotify: (ctx, res) {
              // res içinde Download klasöründeki kesin dosya yolları vardır.
              //
              // showBackupNotification parametre sırası:
              //   csvPath, jsonPath, excelPath
              //
              showBackupNotification(
                ctx,
                res.csvPath,
                res.jsonPath,
                res.excelPath,
              );
            },
          );

          // ==========================================================
          // 🧭 Drawer ’ı güvenli şekilde kapat
          // ==========================================================
          //
          // Export süreci async olduğu için işlem bitene kadar context değişmiş
          // olabilir. Bu yüzden önce mounted kontrolü yapıyoruz.
          //
          // maybePop() kullanımı:
          // • Drawer açıksa kapanır
          // • pop edilecek bir şey yoksa sessizce false döner
          // • Navigator hatası üretmez
          //
          if (!context.mounted) return;
          Navigator.of(context).maybePop();
        },
      ),
    );
  }
}