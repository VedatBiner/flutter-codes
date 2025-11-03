// 📃 <----- lib/utils/fc_files/date_formatter.dart ----->
//
// 🗓️ Tarih Biçimlendirici Yardımcı (Date Formatter)
//
// Amaç:
//   CSV veya JSON verilerindeki tarihlerin Amerikan formatından
//   (aa/gg/yy veya mm/dd/yy) Avrupa formatına (gg/aa/yy) dönüştürülmesi.
//
// Kullanım:
//   import 'fc_files/date_formatter.dart';
//
//   final yeniTarih = formatUsToEuDate("12/31/25");
//   print(yeniTarih); // 👉 "31/12/25"
//
// -----------------------------------------------------------

import 'dart:developer';

/// 🇺🇸→🇪🇺 Tarih formatını dönüştürür: "aa/gg/yy" → "gg/aa/yy"
///
/// Eğer format hatalıysa orijinal değeri döndürür.
/// Örneğin:
///   - "12/05/25" → "05/12/25"
///   - "5/7/2025" → "07/05/2025"
///   - "2025-01-01" → "2025-01-01" (format tanınmaz)
String formatUsToEuDate(String input) {
  try {
    final parts = input.split('/');
    if (parts.length != 3) return input;

    final month = parts[0].padLeft(2, '0');
    final day = parts[1].padLeft(2, '0');
    final year = parts[2].padLeft(2, '0');

    final formatted = '$day/$month/$year';
    log('🗓️ formatUsToEuDate: $input → $formatted', name: 'DateFormatter');
    return formatted;
  } catch (e) {
    log('⚠️ Tarih biçimlendirme hatası: $e', name: 'DateFormatter');
    return input;
  }
}
