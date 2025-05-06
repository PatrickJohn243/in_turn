import 'package:flutter/foundation.dart';

class ProfileReloaderProvider extends ChangeNotifier {
  bool _shouldReload = false;

  bool get shouldReload => _shouldReload;

  void triggerReload() {
    _shouldReload = true;
    notifyListeners();
  }

  void reset() {
    _shouldReload = false;
    notifyListeners();
  }
}
