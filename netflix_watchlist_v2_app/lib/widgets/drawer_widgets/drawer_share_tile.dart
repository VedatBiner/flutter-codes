// 📁 lib/widgets/drawer_widgets/drawer_share_tile.dart
//
// ============================================================================
// 📤 DrawerShareTile – Yedek Dosyaları Paylaşma Satırı
// ============================================================================
//
// Bu widget, Drawer menüsü içinde yer alan
// “Yedekleri Paylaş” ListTile bileşenini üretir.
//
// ---------------------------------------------------------------------------
// 🎯 Sorumlulukları
// ---------------------------------------------------------------------------
// • Kullanıcıya Download klasöründeki yedek dosyaları paylaşma imkanı sunar.
// • Drawer kapatıldıktan sonra paylaşım işlemini başlatır.
// • Paylaşım tamamlandıktan sonra kullanıcıya bilgilendirme gösterir.
//
// ---------------------------------------------------------------------------
// 🔎 Mimari Not
// ---------------------------------------------------------------------------
// Paylaşım işlemi burada yapılmaz.
// shareBackupFolder() yardımcı fonksiyonu (utils/share_helper.dart)
// gerçek paylaşım işlemini üstlenir.
//
// Bu widget yalnızca:
//   → UI üretir
//   → Akışı tetikler
//   → Sonrasında bildirim gösterir
//
// ============================================================================

import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../utils/share_helper.dart';
import '../show_notification_handler.dart';

/// =========================================================================
/// 📤 DrawerShareTile
/// =========================================================================
/// Drawer içinde görünen “Yedekleri Paylaş” menü öğesidir.
///
/// Kullanıcı bu satıra dokunduğunda:
/// 1️⃣ Drawer kapanır.
/// 2️⃣ shareBackupFolder() çağrılır.
/// 3️⃣ İşlem sonrası kullanıcıya bilgilendirme gösterilir.
///
/// Not:
/// Bu widget stateless ’tir.
/// İç state tutmaz; yalnızca aksiyon tetikler.
/// =========================================================================
class DrawerShareTile extends StatelessWidget {
  const DrawerShareTile({super.key});

  /// =========================================================================
  /// 🏗 build
  /// =========================================================================
  /// Drawer içindeki ListTile’ı üretir.
  ///
  /// UI Yapısı:
  /// • leading  → paylaş ikonlu görsel
  /// • title    → ana metin
  /// • subtitle → açıklama metni
  ///
  /// onTap Akışı:
  /// ------------------------------------------------------------
  /// 1️⃣ Drawer context ’i kapanmadan önce rootCtx olarak saklanır.
  ///    Neden?
  ///    Drawer kapandıktan sonra eski context geçersiz olabilir.
  ///
  /// 2️⃣ Drawer kapatılır.
  ///    UX açısından önce menü kapanmalı, sonra sistem paylaşım
  ///    ekranı açılmalıdır.
  ///
  /// 3️⃣ shareBackupFolder() çağrılır.
  ///    Bu fonksiyon:
  ///      - Download klasöründeki JSON/CSV/XLSX dosyalarını bulur
  ///      - Platform share sheet ’i açar
  ///
  /// 4️⃣ Paylaşım tamamlandıktan sonra:
  ///    rootCtx hâlâ mounted ise kullanıcıya bilgi gösterilir.
  ///
  /// mounted kontrolü:
  /// Widget ağacı değişmişse setState/snack bar gibi işlemler
  /// crash olmaması için mounted kontrolü yapılır.
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.share,
        color: downLoadButtonColor,
        size: 32,
      ),

      title: const Text(
        "Yedekleri Paylaş",
        style: drawerMenuText,
      ),

      subtitle: Text(
        "Download klasöründeki\ndosyaları paylaş",
        style: drawerMenuSubtitleText,
      ),

      onTap: () async {
        // 🔹 Drawer kapanmadan önce context ’i sakla
        final rootCtx = context;

        // 🔹 Önce Drawer ’ı kapat (UX için daha temiz)
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        // 🔹 Paylaşım işlemini başlat
        await shareBackupFolder();

        // 🔹 Widget hâlâ aktif mi kontrol et
        if (!rootCtx.mounted) return;

        // 🔹 Kullanıcıya bilgilendirme göster
        showShareFilesNotification(rootCtx);
      },
    );
  }
}