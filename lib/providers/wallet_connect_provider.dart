import 'package:flutter/material.dart';
import 'package:nft_fraction/services/wallet_connect_service.dart';

class WalletConnectProvider extends ChangeNotifier {
  late WalletConnectService walletService;

  void initWalletService(BuildContext context) {
    walletService = WalletConnectService(context: context);
    walletService.initWalletService();
  }

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

  String walletAddess = '';

  void setWalletAddress(String value) {
    walletAddess = value;
    notifyListeners();
  }
}
