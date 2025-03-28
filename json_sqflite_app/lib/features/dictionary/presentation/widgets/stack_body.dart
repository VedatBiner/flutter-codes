// <----- 📜 stack_body.dart ----->
// -----------------------------------------------------------------------------
// Body oluşturmak için kullanılan widget
// -----------------------------------------------------------------------------
//
import 'package:flutter/material.dart';
import 'alphabet_list_widget.dart';

import '../../../../widgets/loading_card.dart';

class StackBody extends StatelessWidget {
  final bool isLoading;
  final double progress;
  final bool showLoadedMessage;
  final Map<String, List<Map<String, dynamic>>> groupedData;

  const StackBody({
    super.key,
    required this.isLoading,
    required this.progress,
    required this.showLoadedMessage,
    required this.groupedData,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isLoading)
          LoadingCard(progress: progress)
        else
          AlphabetListWidget(groupedData: groupedData),
        if (showLoadedMessage)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Card(
                color: Colors.green.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "✅ Yüklendi!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}