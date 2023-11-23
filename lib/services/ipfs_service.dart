import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nft_fraction/constants.dart';
import 'package:nft_fraction/providers/wallet_connect_provider.dart';
import 'package:provider/provider.dart';

class IpfsService {
  final ImagePicker picker = ImagePicker();

  final Dio dio = Dio();

  Future<String> uploadImage() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) {
        const SnackBar(
          content: Text(
            'Error at image picker: image is null',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        );

        throw Exception();
      } else {
        FormData formData = FormData.fromMap(
          {
            'file': await MultipartFile.fromFile(
              image.path,
              filename: image.name,
            ),
          },
        );

        final Response response = await dio.post(
          'https://api.nftport.xyz/v0/files',
          options: Options(
            headers: {
              'Authorization': nftPortApiKey,
              'Content-Type': 'multipart/form-data',
              'Accept': 'application/json',
            },
          ),
          data: formData,
        );

        final result = response.data;

        final imageUri = result['ipfs_url'];

        debugPrint(imageUri);

        return imageUri;
      }
    } on DioException catch (error) {
      debugPrint('Error at image upload: $error');
      debugPrint(error.message);
      debugPrint(error.response?.data.toString() ?? '');

      SnackBar(
        content: Text(
          'Error at image upload: $error',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      );

      return 'Error at image upload: $error';
    } catch (error) {
      debugPrint('Error at image upload: $error');

      SnackBar(
        content: Text(
          'Error at image upload: $error',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      );

      return 'Error at image upload: $error';
    }
  }

  Future<String> uploadMetadata() async {
    try {
      final String imageUri = await uploadImage();

      final Response response = await dio.post(
        'https://api.nftport.xyz/v0/metadata',
        options: Options(
          headers: {
            'Authorization': nftPortApiKey,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: jsonEncode(
          {
            'file_url': imageUri,
            'name': 'F.eth',
            'description': 'Fraction.eth NFT',
          },
        ),
      );

      final result = response.data;

      final metadataUri = '$ipfsBaseUrl${result["metadata_uri"].substring(7)}';

      debugPrint(metadataUri);

      return metadataUri;
    } on DioException catch (error) {
      debugPrint('Error at metadata upload: $error');
      debugPrint(error.message);
      debugPrint(error.response?.data.toString() ?? '');

      SnackBar(
        content: Text(
          'Error at metadata upload: $error',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      );

      return 'Error at metadata upload: $error';
    } catch (error) {
      debugPrint('Error at metadata upload: $error');

      SnackBar(
        content: Text(
          'Error at metadata upload: $error',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      );

      return 'Error at metadata upload: $error';
    }
  }

  Future<void> mintNft(BuildContext context) async {
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

      final String metadataUri = await uploadMetadata();

      late String mintToAddress;

      if (context.mounted) {
        mintToAddress =
            Provider.of<WalletConnectProvider>(context, listen: false)
                .walletAddess;
      }

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
            "metadata_uri": metadataUri,
            "mint_to_address": mintToAddress,
          },
        ),
      );

      final result = response.data;

      debugPrint('Minting response: @$result');

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
