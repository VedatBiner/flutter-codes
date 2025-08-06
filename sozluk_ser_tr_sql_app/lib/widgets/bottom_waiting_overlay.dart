// 📃 utils/bottom_waiting_overlay.dart
//
// Ekranın altına sabitlenen, gölgeli “Lütfen bekleyiniz” paneli
//

import 'package:flutter/material.dart';

class BottomWaitingOverlay extends StatelessWidget {
  const BottomWaitingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        // gölge verir
        elevation: 12,
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: 28,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 24),
              Text(
                'Lütfen bekleyiniz…',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
