// 📃 <----- sql_loading_card.dart ----->
//
// Verilerin tekrar yüklenmesi cihaz ekranında bu kart ile gösteriliyor.
//  • progress      → 0‒1 arası yüzde
//  • loadingWord   → O an eklenen kelime (null → gizli)
//  • elapsedTime   → Kronometre; her yeniden-build’de güncellenir.
//

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';

class SQLLoadingCard extends StatelessWidget {
  final double progress;
  final String? loadingWord;
  final Duration elapsedTime;

  const SQLLoadingCard({
    super.key,
    required this.progress,
    required this.loadingWord,
    required this.elapsedTime,
  });

  /// 🔠 mm:ss formatına çevir
  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 📌 Mavi arka planlı başlık
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: drawerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text("Veriler Yenileniyor", style: dbLoadingMsgText),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 📌 Lottie animasyonu
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Lottie.asset(
                      'assets/animations/fileupload.json',
                      repeat: true,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 📌 Kronometre
                  Text(
                    "Geçen Süre: ${_formatDuration(elapsedTime)}",
                    style: veriYukleniyor,
                  ),

                  const SizedBox(height: 12),

                  // 📌 İlerleme yüzdesi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Veriler Yükleniyor...",
                        style: veriYukleniyor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${(progress * 100).toStringAsFixed(2)}%",
                        style: veriYuzdesi,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 12),

                  // 📌 Eklenen kelime
                  if (loadingWord != null)
                    Text(loadingWord!, style: loadingWordText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
