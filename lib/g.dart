import 'package:flutter/material.dart';

class G with ChangeNotifier {
  bool _activeButtonRVChat = false;

  bool get activeButtonRVChat => _activeButtonRVChat;

  set active(bool value) {
    _activeButtonRVChat = value;
    notifyListeners();
  }
}
