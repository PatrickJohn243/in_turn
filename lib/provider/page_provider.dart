import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int pageIndex) {
    _currentIndex = pageIndex;
    notifyListeners();
  }
}
