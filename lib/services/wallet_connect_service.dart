import 'package:flutter/material.dart';
import 'package:nft_fraction/providers/wallet_connect_provider.dart';
import 'package:nft_fraction/utils/string_constants.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class WalletConnectService {
  late Web3App web3App;

  late W3MService w3mService;

  late WalletConnectProvider provider;

  Future<void> initWalletService(BuildContext context) async {
    web3App = await Web3App.createInstance(
      projectId: '3f271949a264a21c076cba504199dca9',
      logLevel: LogLevel.error,
      metadata: const PairingMetadata(
        name: 'F.eth',
        description: 'NFT Fractionization',
        url: 'https://www.walletconnect.com/',
        icons: ['https://web3modal.com/images/rpc-illustration.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );

    web3App.onSessionPing.subscribe(onSessionPing);
    web3App.onSessionEvent.subscribe(onSessionEvent);

    await web3App.init();

    print('init 1');

    if (context.mounted) {
      Provider.of<WalletConnectProvider>(context, listen: false)
          .setInitialized(true);
    }

    web3App.onSessionConnect.subscribe(onWeb3AppConnect);
    web3App.onSessionDelete.subscribe(onWeb3AppDisconnect);

    w3mService = W3MService(
      web3App: web3App,
      // featuredWalletIds: {
      //   'f2436c67184f158d1beda5df53298ee84abfc367581e4505134b5bcf5f46697d',
      //   '8a0ee50d1f22f6651afcae7eb4253e52a3310b90af5daef78a8c4929a9bb99d4',
      //   'f5b4eeb6015d66be3f5940a895cbaa49ef3439e518cd771270e6b553b48f31d2',
      // },
    );

    // W3MChainPresets.chains.putIfAbsent('11155111', () => sepoliaTestnet);

    await w3mService.init();

    print('init 2');
  }

  void onSessionPing(SessionPing? args) {
    debugPrint('[$runtimeType] ${StringConstants.receivedPing}: $args');
  }

  void onSessionEvent(SessionEvent? args) {
    debugPrint('[$runtimeType] ${StringConstants.receivedEvent}: $args');
  }

  void onWeb3AppConnect(SessionConnect? args) {
    debugPrint('$args');
  }

  void onWeb3AppDisconnect(SessionDelete? args) {
    debugPrint('$args');
  }
}
