import 'package:flutter/material.dart';
import 'package:nft_fraction/providers/wallet_connect_provider.dart';
import 'package:nft_fraction/storage/secure_storage.dart';
import 'package:nft_fraction/utils/string_constants.dart';
import 'package:nft_fraction/view/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class WalletConnectService {
  late Web3App web3App;

  late W3MService w3mService;

  late WalletConnectProvider provider;

  late BuildContext context;

  final SecureStorage storage = SecureStorage();

  WalletConnectService({required this.context});

  Future<void> initWalletService() async {
    final String address = await storage.readAddress() ?? '';

    final String connected = await storage.readConnected() ?? '';

    if (address.isNotEmpty) {
      // ignore: use_build_context_synchronously
      provider = Provider.of<WalletConnectProvider>(context, listen: false);

      provider.setWalletAddress(address);

      if (connected == 'true') {
        provider.setConnected(true);
      }
    }

    web3App = await Web3App.createInstance(
      projectId: '3f271949a264a21c076cba504199dca9',
      logLevel: LogLevel.error,
      metadata: const PairingMetadata(
        name: 'F.eth',
        description: 'Fraction.eth',
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

    debugPrint('init 1');

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

    debugPrint('init 2');
  }

  void onSessionPing(SessionPing? args) {
    debugPrint(
        'Session ping [$runtimeType] ${StringConstants.receivedPing}: $args');
  }

  void onSessionEvent(SessionEvent? args) {
    debugPrint(
        'Session Event [$runtimeType] ${StringConstants.receivedEvent}: $args');
  }

  void onWeb3AppConnect(SessionConnect? args) {
    debugPrint('Connect $args');

    final String walletAddress = args!
        .session.namespaces.entries.first.value.accounts.first
        .split(':')
        .last;

    debugPrint('address $walletAddress');

    provider = Provider.of<WalletConnectProvider>(context, listen: false);

    storage.setAddress(walletAddress);

    provider.setWalletAddress(walletAddress);

    storage.setConnected('true');

    provider.setConnected(true);

    debugPrint('done');
  }

  void onWeb3AppDisconnect(SessionDelete? args) {
    debugPrint('Disconnect $args');

    provider = Provider.of<WalletConnectProvider>(context, listen: false);

    provider.setConnected(false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
      (route) => false,
    );
  }
}
