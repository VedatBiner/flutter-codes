/// <----- language_listener.dart ----->
library;
import 'package:flutter/material.dart';

class LanguageListener extends ValueNotifier<bool> {
  LanguageListener(super.value);

  void changeLang() {
    value = !value;
    notifyListeners();
  }
}

class LanguageManager extends InheritedWidget {
  final bool value;
  final VoidCallback changeLang;

  const LanguageManager({
    required this.value,
    required this.changeLang,
    required super.child,
    super.key,
  });

  static LanguageManager? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LanguageManager>();
  }

  static bool of(BuildContext context) {
    final values = maybeOf(context);
    assert(values != null, "No languageManager not found in context");
    return values!.value;
  }

  @override
  bool updateShouldNotify(LanguageManager oldWidget) {
    return value != oldWidget.value;
  }
}
