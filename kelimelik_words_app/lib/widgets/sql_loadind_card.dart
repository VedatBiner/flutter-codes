// 📃 <----- sql_loading_card.dart ----->

import 'package:flutter/material.dart';

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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Veriler Yükleniyor...", style: veriYukleniyor),
                  const SizedBox(width: 8),
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: veriYuzdesi,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 12),
              if (loadingWord != null)
                Text(
                  loadingWord!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
