// <----- 📜 loading_card.dart ----->
// -----------------------------------------------------------------------------
// Kelime listesi oluşturmak için kullanılan widget
// Burada kelimelerin veri tabanına eklenmesi yüzde ve bir progress bar
// olarak görüntüleniyor.
// -----------------------------------------------------------------------------
//
import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  final double progress;

  const LoadingCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(20),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Veriler ekleniyor... "),
                  Text(
                    "${(progress * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: progress),
            ],
          ),
        ),
      ),
    );
  }
}










