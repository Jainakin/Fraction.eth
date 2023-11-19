import 'package:flutter/material.dart';
import 'package:nft_fraction/providers/wallet_connect_provider.dart';
import 'package:nft_fraction/providers/wallet_nfts_provider.dart';
import 'package:nft_fraction/providers/welcome_page_provider.dart';
import 'package:nft_fraction/view/home/home_screen.dart';
import 'package:nft_fraction/view/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themeData = Web3ModalThemeData(
    darkColors: Web3ModalColors.darkMode.copyWith(
      accent100: Colors.purple,
      background125: Colors.black,
    ),
  );

  // @override
  // void initState() {
  //   super.initState();
  //   // WidgetsBinding.instance.addObserver(this);
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     setState(() {
  //       final platformDispatcher = View.of(context).platformDispatcher;
  //       final platformBrightness = platformDispatcher.platformBrightness;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: WelcomePageProvider(),
        ),
        ChangeNotifierProvider.value(
          value: WalletNftsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: WalletConnectProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Fractional.eth',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(brightness: Brightness.dark),
        home: Web3ModalTheme(
          themeData: themeData,
          isDarkMode: true,
          child: const WelcomeScreen(),
        ),
      ),
    );
  }
}
