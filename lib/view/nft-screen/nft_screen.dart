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

class NftScreen extends StatefulWidget {
  const NftScreen({super.key});

  @override
  State<NftScreen> createState() => _NftScreenState();
}

class _NftScreenState extends State<NftScreen> {
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
