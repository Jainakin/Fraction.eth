import 'package:flutter/material.dart';
import 'package:nft_fraction/models/alchemy_nft.dart';

class WalletNftsProvider extends ChangeNotifier {
  //// WALLET NFTS LOADING ////
  bool walletNftsLoading = false;

  void setWalletNftsLoading(bool loading) {
    walletNftsLoading = loading;
    notifyListeners();
  }
  //// WALLET NFTS LOADING ////

  //// WALLET NFTS ////
  List<AlchemyNft> walletNfts = [];

  void setWalletNfts(List<AlchemyNft> nfts) {
    walletNfts = nfts;
    notifyListeners();
  }

  void addWalletNfts(List<AlchemyNft> nfts) {
    walletNfts.addAll(nfts);
    notifyListeners();
  }
  //// WALLET NFTS ////
}
