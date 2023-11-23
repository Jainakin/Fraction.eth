import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_fraction/models/alchemy_nft.dart';
import 'package:nft_fraction/providers/wallet_nfts_provider.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class AlchemyNftService {
  final Dio dio = Dio();

  late WalletNftsProvider walletNftsProvider;

  AlchemyNftService(BuildContext context) {
    dio.options.headers['Authorization'] = 'Bearer $alchemyApiKeyPolygon';
    walletNftsProvider =
        Provider.of<WalletNftsProvider>(context, listen: false);
  }

  Future<void> getWalletNfts({required String walletAddress}) async {
    try {
      walletNftsProvider.setWalletNftsLoading(true);

      dio.options.headers['Authorization'] = 'Bearer $alchemyApiKeyPolygon';

      final Response response = await dio.get(
        'https://polygon-mainnet.g.alchemy.com/nft/v2/getNFTs?owner=$walletAddress&withMetadata=true',
      );

      final result = response.data['ownedNfts'];

      debugPrint(result.toString());

      List<AlchemyNft> nfts = [];

      for (var nft in result) {
        nfts.add(AlchemyNft.fromJson(nft));
      }

      walletNftsProvider.setWalletNfts(nfts);

      walletNftsProvider.setWalletNftsLoading(false);
    } on DioException catch (error) {
      debugPrint('Dio Error getting wallet NFTs');

      debugPrint(error.message);

      debugPrint(error.response.toString());

      walletNftsProvider.setWalletNftsLoading(false);
    } catch (error) {
      debugPrint('Error getting wallet NFTs');

      debugPrint(error.toString());

      walletNftsProvider.setWalletNftsLoading(false);
    }
  }

  Future<void> fractionizeNfts({
    required BuildContext context,
    required String walletAddress,
    required int index,
  }) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return Platform.isAndroid
              ? const CircularProgressIndicator(
                  color: CupertinoColors.activeBlue,
                )
              : const CupertinoActivityIndicator(
                  color: CupertinoColors.activeBlue,
                );
        },
      );

      final Response response = await dio.post(
        'https://api.nftport.xyz/v0/mints/customizable',
        options: Options(
          headers: {
            'Authorization': nftPortApiKey,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: jsonEncode(
          {
            "chain": "polygon",
            "contract_address": mintingContractAddress,
            "metadata_uri":
                'https://ipfs.io/ipfs/bafkreib4smsnqhyjgmravxiy62qleefn5wazxjrmzgsp3bxnnid54gsnme',
            "mint_to_address": walletAddress,
          },
        ),
      );

      final result = response.data;

      debugPrint('Minting response: @$result');

      if (context.mounted) {
        Provider.of<WalletNftsProvider>(context, listen: false)
            .removeWalletNft(index);
      }

      if (context.mounted) {
        Navigator.pop(context);
      }

      return;
    } on DioException catch (error) {
      debugPrint('Error at minting: $error');
      debugPrint(error.message);
      debugPrint(error.response?.data.toString() ?? '');

      if (context.mounted) {
        Navigator.pop(context);
      }

      SnackBar(
        content: Text(
          'Error at minting: $error',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      );

      return;
    } catch (error) {
      debugPrint('Error at minting: $error');

      if (context.mounted) {
        Navigator.pop(context);
      }

      SnackBar(
        content: Text(
          'Error at minting: $error',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      );

      return;
    }
  }
}
