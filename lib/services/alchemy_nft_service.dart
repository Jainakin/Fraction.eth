import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nft_fraction/models/alchemy_nft.dart';
import 'package:nft_fraction/providers/wallet_nfts_provider.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class AlchemyNftService {
  final Dio dio = Dio();

  late WalletNftsProvider walletNftsProvider;

  AlchemyNftService(BuildContext context) {
    dio.options.headers['Authorization'] = 'Bearer $alchemyApiKeyGoerli';
    walletNftsProvider =
        Provider.of<WalletNftsProvider>(context, listen: false);
  }

  Future<void> getWalletNfts({required String walletAddress}) async {
    try {
      walletNftsProvider.setWalletNftsLoading(true);

      dio.options.headers['Authorization'] = 'Bearer $alchemyApiKeyPolygon';

      final Response response = await dio.get(
        'https://eth-goerli.g.alchemy.com/nft/v2/getNFTs?owner=$walletAddress&withMetadata=true',
        // 'https://polygon-mainnet.g.alchemy.com/nft/v2/$alchemyApiKeyPolygon/getNFTs?owner=$walletAddress&withMetadata=true&pageSize=100',
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
}
