import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_fraction/providers/wallet_connect_provider.dart';
import 'package:nft_fraction/providers/welcome_page_provider.dart';
import 'package:nft_fraction/view/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<WalletConnectProvider>(context, listen: false)
        .initWalletService(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Consumer<WelcomePageProvider>(
        builder: (context, provider, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  key: ValueKey<int>(provider.page + 1),
                  height: screenHeight + 0.6,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/${provider.page + 1}.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(height: MediaQuery.of(context).padding.top),
                  Expanded(
                    child: Center(
                      child: Container(
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
                    ),
                  ),
                  // const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 32.0),
                    width: double.infinity,
                    // height: screenHeight * 0.4,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'F.eth',
                          style: GoogleFonts.dmSans(
                            fontSize: 48.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Mint',
                                style: GoogleFonts.dmSans(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                  color: CupertinoColors.activeBlue,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: GoogleFonts.dmSans(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: 'Fractionalize',
                                style: GoogleFonts.dmSans(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                  color: CupertinoColors.activeBlue,
                                ),
                              ),
                              TextSpan(
                                text: ' NFTs Quickly',
                                style: GoogleFonts.dmSans(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Provider.of<WalletConnectProvider>(context).initialized
                            ? Column(
                                children: [
                                  W3MNetworkSelectButton(
                                    service: Provider.of<WalletConnectProvider>(
                                            context)
                                        .walletService
                                        .w3mService,
                                  ),
                                  const SizedBox(height: 16.0),
                                  W3MConnectWalletButton(
                                    service: Provider.of<WalletConnectProvider>(
                                            context)
                                        .walletService
                                        .w3mService,
                                    state: ConnectButtonState.none,
                                  ),
                                ],
                              )
                            : const CupertinoActivityIndicator(
                                color: Colors.blue,
                              ),
                        const SizedBox(height: 16),
                        CupertinoButton(
                          borderRadius: BorderRadius.circular(50.0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Continue',
                            style: GoogleFonts.dmSans(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                MediaQuery.of(context).padding.bottom + 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
