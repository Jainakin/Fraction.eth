import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_fraction/providers/wallet_connect_provider.dart';
import 'package:nft_fraction/providers/wallet_nfts_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/alchemy_nft_service.dart';

class FractionizeScreen extends StatefulWidget {
  const FractionizeScreen({super.key});

  @override
  State<FractionizeScreen> createState() => _FractionizeScreenState();
}

class _FractionizeScreenState extends State<FractionizeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        AlchemyNftService(context).getWalletNfts(
          walletAddress:
              Provider.of<WalletConnectProvider>(context, listen: false)
                  .walletAddess,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 10,
        backgroundColor: Colors.black,
        elevation: 4.0,
        title: Text(
          'Wallet NFTs',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Consumer<WalletNftsProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: provider.walletNftsLoading
                        ? Center(
                            child: Platform.isAndroid
                                ? const CircularProgressIndicator(
                                    color: CupertinoColors.activeBlue,
                                  )
                                : const CupertinoActivityIndicator(
                                    color: CupertinoColors.activeBlue,
                                  ),
                          )
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              mainAxisSpacing: 12.0,
                              crossAxisSpacing: 12.0,
                            ),
                            itemCount: provider.walletNfts.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: Colors.black,
                                      builder: (BuildContext context) {
                                        return FractionizeModalSheet(
                                            index: index);
                                      },
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: provider.walletNfts[index].image!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) {
                                      return Shimmer.fromColors(
                                        baseColor: const Color(0xFF23262F),
                                        highlightColor: const Color(0xFF2D3038),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[900],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// class FractionizeScreen extends StatefulWidget {
//   const FractionizeScreen({super.key});

//   @override
//   State<FractionizeScreen> createState() => _FractionizeScreenState();
// }

// class _FractionizeScreenState extends State<FractionizeScreen> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) {
//         AlchemyNftService(context).getWalletNfts(
//           walletAddress:
//               Provider.of<WalletConnectProvider>(context, listen: false)
//                   .walletAddess,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         toolbarHeight: kToolbarHeight + 10,
//         backgroundColor: Colors.black,
//         elevation: 4.0,
//         title: Text(
//           'Select NFT',
//           style: GoogleFonts.dmSans(
//             color: Colors.white,
//             fontSize: 20.0,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           SafeArea(
//             bottom: false,
//             child: Consumer<WalletNftsProvider>(
//               builder: (context, provider, child) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: provider.walletNftsLoading
//                             ? Center(
//                                 child: Platform.isAndroid
//                                     ? const CircularProgressIndicator(
//                                         color: CupertinoColors.activeBlue,
//                                       )
//                                     : const CupertinoActivityIndicator(
//                                         color: CupertinoColors.activeBlue,
//                                       ),
//                               )
//                             : GridView.builder(
//                                 physics: const BouncingScrollPhysics(),
//                                 gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 2,
//                                   childAspectRatio: 1.0,
//                                   mainAxisSpacing: 12.0,
//                                   crossAxisSpacing: 12.0,
//                                 ),
//                                 itemCount: provider.walletNfts.length,
//                                 itemBuilder: (context, index) {
//                                   return GestureDetector(
//                                     onTap: () {
//                                       showModalBottomSheet<void>(
//                                         context: context,
//                                         backgroundColor: Colors.black,
//                                         builder: (BuildContext context) {
//                                           return FractionizeModalSheet(
//                                               index: index);
//                                         },
//                                       );
//                                     },
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(8.0),
//                                       child: CachedNetworkImage(
//                                         imageUrl:
//                                             provider.walletNfts[index].image!,
//                                         fit: BoxFit.cover,
//                                         placeholder: (context, url) {
//                                           return Shimmer.fromColors(
//                                             baseColor: const Color(0xFF23262F),
//                                             highlightColor:
//                                                 const Color(0xFF2D3038),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 color: Colors.grey[900],
//                                                 borderRadius:
//                                                     BorderRadius.circular(8.0),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         errorWidget: (context, url, error) {
//                                           return const Icon(Icons.error);
//                                         },
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class FractionizeModalSheet extends StatefulWidget {
  const FractionizeModalSheet({super.key, required this.index});

  final int index;

  @override
  State<FractionizeModalSheet> createState() => _FractionizeModalSheetState();
}

class _FractionizeModalSheetState extends State<FractionizeModalSheet> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      volumeController.text = '1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
      child: Container(
        // height: 300,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Address',
              style: GoogleFonts.dmSans(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            CupertinoTextField(
              placeholder: '0xff....ff',
              keyboardType: TextInputType.text,
              decoration: BoxDecoration(
                // color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: CupertinoColors.white),
              ),
              style: const TextStyle(color: CupertinoColors.white),
              controller: addressController,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Enter Volume',
              style: GoogleFonts.dmSans(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            CupertinoTextField(
              placeholder: 'Volume',
              keyboardType: TextInputType.text,
              decoration: BoxDecoration(
                // color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: CupertinoColors.white),
              ),
              style: const TextStyle(color: CupertinoColors.white),
              controller: volumeController,
            ),
            const SizedBox(height: 24.0),
            Center(
              child: CupertinoButton.filled(
                child: Text(
                  'Submit',
                  style: GoogleFonts.dmSans(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  AlchemyNftService(context).fractionizeNfts(
                    context: context,
                    walletAddress: addressController.text,
                    index: widget.index,
                  );

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
