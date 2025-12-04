import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Güvenli şekilde HardwareKeyboard.instance çağırır.
/// Binding hazır değilse hiçbir şey yapmaz.
void safeClearKeyboardState() {
  try {
    if (WidgetsBinding.instance != null) {
      HardwareKeyboard.instance.clearState();
    }
  } catch (_) {
    // binding hazır değilse sessiz geç
  }
}
