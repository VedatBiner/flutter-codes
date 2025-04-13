// 📃 <----- sql_loading_card.dart ----->
// Verilerin tekrar yüklenmesi cihazda buradan izleniyor

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';

class SQLLoadingCard extends StatelessWidget {
  final double progress;
  final String? loadingWord;

  const SQLLoadingCard({
    super.key,
    required this.progress,
    required this.loadingWord,
  });

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
            /// 📌 Mavi arka planlı başlık
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
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 4,
                    ),
                  ),

                  const SizedBox(height: 16),

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
