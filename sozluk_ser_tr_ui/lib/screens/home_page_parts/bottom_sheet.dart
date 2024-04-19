/// <----- build_bottom_sheet.dart ----->
library;

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../services/word_service.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final WordService wordService = WordService();
    return Container(
      color: menuColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: StreamBuilder<int>(
        stream: wordService.getDocumentCountStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Girilen kelime sayısı: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    '${snapshot.data}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Girilen kelime sayısı: Hesaplanamadı',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
