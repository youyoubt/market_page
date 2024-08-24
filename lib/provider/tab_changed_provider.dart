import 'package:flutter/material.dart';

/// tab changed provider
class TabChangedProvider extends ChangeNotifier {
  int _tabIndex = 0;

  set tabIndex(int value) {
    if (value != _tabIndex) {
      _tabIndex = value;
      notifyListeners();
    }
  }

  int get tabIndex => _tabIndex;
}
