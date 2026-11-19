// 📃 <----- database_reset_helper.dart ----->
//
// Veritabanını tamamen temizlemek için ortak fonksiyon.
// İstediğiniz widget ’tan ‟await showResetDatabaseDialog(context, onAfterReset);”
// şeklinde çağırabilirsiniz.

// 📌 Flutter hazır paketleri
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../providers/item_count_provider.dart';
import '../services/notification_service.dart';
import '../widgets/confirmation_dialog.dart';

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

  /// Eğer kullanıcı vazgeçtiyse hemen çık
  if (confirm != true) return;

  /// 🔄 1️⃣ Drawer ’ı kapat
  ///    showConfirmationDialog sadece AlertDialog 'ı kapatır,
  ///    bu adım Drawer’ için gerekiyor.
  if (!context.mounted) return;
  Navigator.of(context).maybePop();

  // 🔥 2️⃣ Tablodaki tüm verileri sil
  final db = await DbHelper.instance.database;
  await db.delete('words');

  /// 3️⃣ Eğer widget tree ’den ayrıldıysak işleme devam etmeyelim
  if (!context.mounted) return;

  /// 4️⃣ Provider ’daki sayaç sıfırlansın
  Provider.of<WordCountProvider>(context, listen: false).setCount(0);

  /// 🔑 5️⃣ MediaQuery garantisi için rootContext
  final rootCtx = Navigator.of(context, rootNavigator: true).context;

  /// 🔔 6️⃣ Bildirimi göster
  NotificationService.showCustomNotification(
    context: rootCtx,
    title: 'Veritabanı Sıfırlandı',
    message: const Text('Tüm kayıtlar silindi.'),
    icon: Icons.delete_forever,
    iconColor: Colors.red,
    progressIndicatorColor: Colors.red,
    progressIndicatorBackground: Colors.red.shade100,
  );

  /// 🔁 7️⃣ İşlem sonrası callback
  onAfterReset();
}
