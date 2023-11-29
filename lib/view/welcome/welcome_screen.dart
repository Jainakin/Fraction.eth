import 'dart:ui';

import 'package:action_slider/action_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
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
            alignment: Alignment.topCenter,
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
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 32.0),
                width: double.infinity,
                height: screenHeight,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Fraction.eth',
                      style: GoogleFonts.dmSans(
                        fontSize: 48.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Mint',
                            style: GoogleFonts.dmSans(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: CupertinoColors.activeBlue,
                              // color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: GoogleFonts.dmSans(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: 'Fractionalize',
                            style: GoogleFonts.dmSans(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: CupertinoColors.activeBlue,
                              // color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' your creativity effortlessly, giving every collector a unique piece of your genius.',
                            style: GoogleFonts.dmSans(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
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
                                service:
                                    Provider.of<WalletConnectProvider>(context)
                                        .walletService
                                        .w3mService,
                              ),
                              const SizedBox(height: 16.0),
                              W3MConnectWalletButton(
                                service:
                                    Provider.of<WalletConnectProvider>(context)
                                        .walletService
                                        .w3mService,
                                state: ConnectButtonState.none,
                              ),
                            ],
                          )
                        : const CupertinoActivityIndicator(
                            color: CupertinoColors.activeBlue,
                          ),
                    const SizedBox(height: 16),
                    ActionSlider.standard(
                      backgroundColor: Colors.white.withOpacity(0.20),
                      toggleColor: Colors.white,
                      sliderBehavior: SliderBehavior.stretch,
                      borderWidth: 8.0,
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: CupertinoColors.activeBlue,
                        size: 18.0,
                      ),
                      customBackgroundBuilder: (p0, p1, p2) {
                        return Center(
                          child: GradientAnimationText(
                            text: Text(
                              'Slide to start',
                              style: GoogleFonts.dmSans(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            colors: [
                              Colors.white.withOpacity(1.0),
                              Colors.black.withOpacity(0.75),
                            ],
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      successIcon: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      loadingIcon: const CupertinoActivityIndicator(
                        color: CupertinoColors.activeBlue,
                      ),
                      failureIcon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      action: (controller) async {
                        controller.loading();

                        WalletConnectProvider walletProvider =
                            Provider.of<WalletConnectProvider>(context,
                                listen: false);

                        // Provider.of<WalletConnectProvider>(context)
                        //     .walletService
                        //     .w3mService
                        //     .openModal(context);

                        if (walletProvider.connected) {
                          await Future.delayed(const Duration(seconds: 1));

                          controller.success();

                          await Future.delayed(const Duration(seconds: 1));

                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        } else {
                          await Future.delayed(const Duration(seconds: 1));

                          controller.failure();

                          await Future.delayed(const Duration(seconds: 3));

                          controller.reset();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 48.0,
                ),
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
            ],
          );
        },
      ),
    );
  }
}
