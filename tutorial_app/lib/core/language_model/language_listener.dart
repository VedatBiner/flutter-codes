// language_listener.dart
import 'package:flutter/material.dart';

class LanguageListener extends ValueNotifier<bool>{
  LanguageListener(bool value): super(value);

  void changeLang() => value ? false : true;
}

class LanguageManager extends InheritedWidget{
  final bool value;
  final VoidCallback changeLang;

  const LanguageManager({
    required this.value,
    required this.changeLang,
    required Widget child,
    super.key,
  }) : super(child: child);

  static LanguageManager? maybeOf(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<LanguageManager>();
  }

  static bool of(BuildContext context){
    final values = maybeOf(context);
    assert(values != null, "No languageManager not found in context");
    return values!.value;
  }

  @override
  bool updateShouldNotify(LanguageManager oldWidget) {
    return value != oldWidget.value;
  }

}

