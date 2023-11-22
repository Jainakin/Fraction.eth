import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/ipfs_service.dart';
import '../nft-screen/nft_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/1.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 36.0),
                CupertinoButton(
                  onPressed: () {
                    IpfsService().mintNft(context);
                  },
                  color: CupertinoColors.systemFill,
                  child: const Text(
                    'Mint NFT',
                  ),
                ),
                const SizedBox(height: 36.0),
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NftScreen(),
                      ),
                    );
                  },
                  color: CupertinoColors.systemFill,
                  child: const Text(
                    'Check NFTs',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
