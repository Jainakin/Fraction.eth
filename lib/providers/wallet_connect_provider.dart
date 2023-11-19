import 'package:flutter/material.dart';

class WalletConnectProvider extends ChangeNotifier {
  bool initialized = false;

  setInitialized(bool value) {
    initialized = value;
    notifyListeners();
  }

  bool connected = false;

  setConnected(bool value) {
    connected = value;
    notifyListeners();
  }
}
