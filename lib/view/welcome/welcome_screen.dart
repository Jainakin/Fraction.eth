import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:nft_fraction/providers/welcome_page_provider.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<WelcomePageProvider>(
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
                    image: AssetImage('assets/images/${provider.page + 1}.png'),
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlutterCarousel(
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
              ],
            ),
          ],
        );
      },
    );
  }
}
