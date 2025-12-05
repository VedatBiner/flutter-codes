import 'package:flutter/services.dart';

/// Güvenli şekilde HardwareKeyboard.instance çağırır.
/// Binding hazır değilse hiçbir şey yapmaz.
void safeClearKeyboardState() {
  try {
    HardwareKeyboard.instance.clearState();
    } catch (_) {
    // binding hazır değilse sessiz geç
  }
}
