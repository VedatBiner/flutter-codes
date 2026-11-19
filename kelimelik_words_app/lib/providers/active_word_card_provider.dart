import 'package:material_ui/material_ui.dart';

class ActiveWordCardProvider extends ChangeNotifier {
  int? _activeIndex;

  int? get activeIndex => _activeIndex;

  void open(int index) {
    _activeIndex = index;
    notifyListeners();
  }

  void close() {
    if (_activeIndex != null) {
      _activeIndex = null;
      notifyListeners();
    }
  }
}
