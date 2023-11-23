import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_fraction/providers/wallet_connect_provider.dart';
import 'package:nft_fraction/providers/welcome_page_provider.dart';
import 'package:nft_fraction/view/fractionize/fractionize_screen.dart';
import 'package:provider/provider.dart';
import 'package:web3modal_flutter/widgets/buttons/connect_button.dart';
import 'package:web3modal_flutter/widgets/w3m_connect_wallet_button.dart';
import 'package:web3modal_flutter/widgets/w3m_network_select_button.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<WelcomePageProvider>(
        builder: (context, provider, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  key: ValueKey<int>(provider.page + 1),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/${provider.page + 1}.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).padding.top + 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        W3MNetworkSelectButton(
                          service: Provider.of<WalletConnectProvider>(context)
                              .walletService
                              .w3mService,
                        ),
                        const SizedBox(height: 16.0),
                        W3MConnectWalletButton(
                          service: Provider.of<WalletConnectProvider>(context)
                              .walletService
                              .w3mService,
                          state: ConnectButtonState.none,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 64.0),
                  Container(
                    alignment: Alignment.center,
                    child: FlutterCarousel(
                      items: [1, 2, 3].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/$i.png',
                                height: screenWidth * 0.7,
                                width: screenWidth * 0.7,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        controller: provider.carouselController,
                        onPageChanged: (index, reason) {
                          provider.setPage(index);
                        },
                        viewportFraction: 0.7,
                        height: screenWidth * 0.7,
                        showIndicator: false,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        pauseAutoPlayInFiniteScroll: true,
                        autoPlay: true,
                        autoPlayCurve: Curves.linear,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 500),
                      ),
                    ),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    borderRadius: BorderRadius.circular(50.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    onPressed: () {
                      IpfsService().mintNft(context);
                    },
                    child: Text(
                      'Mint',
                      style: GoogleFonts.dmSans(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CupertinoButton(
                    borderRadius: BorderRadius.circular(50.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FractionizeScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Fractionize',
                      style: GoogleFonts.dmSans(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CupertinoButton(
                    borderRadius: BorderRadius.circular(50.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NftScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Wallet Assets',
                      style: GoogleFonts.dmSans(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 16.0),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
