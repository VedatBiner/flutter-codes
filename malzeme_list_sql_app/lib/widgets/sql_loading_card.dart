// 📃 <----- sql_loading_card.dart ----->
//
// Verilerin JSON 'dan tekrar yüklenmesi cihaz ekranında bu kart ile gösterilir.
//  • progress      → 0‒1 arası yüzde
//  • loadingItem   → O an eklenen malzeme (null → gizli)
//  • elapsedTime   → Kronometre; her yeniden build ’de güncellenir.

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// 📌 Yardımcı sabitler
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';

class SQLLoadingCard extends StatelessWidget {
  final double progress;
  final String? loadingItem;
  final Duration elapsedTime;

  const SQLLoadingCard({
    super.key,
    required this.progress,
    required this.loadingItem,
    required this.elapsedTime,
  });

  /// ⏱ Süreyi "mm:ss" formatında gösterir
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
            /// 🔷 Üst başlık: Veriler Yenileniyor
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
                  /// 📁 Lottie yükleme animasyonu
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Lottie.asset(
                      'assets/animations/fileupload.json',
                      repeat: true,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ⏱ Geçen süre
                  Text(
                    "Geçen Süre: ${_formatDuration(elapsedTime)}",
                    style: veriYukleniyor,
                  ),

                  const SizedBox(height: 12),

                  /// 📊 Yüklenme yüzdesi
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

                  /// 📈 Hatay ilerleme çubuğu
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 12),

                  /// 📝 O an eklenen malzeme (eğer varsa)
                  if (loadingItem != null)
                    Text(loadingItem!, style: loadingWordText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
