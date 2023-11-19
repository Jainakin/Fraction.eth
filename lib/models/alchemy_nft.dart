import 'package:flutter/material.dart';

class AlchemyNft {
  String? image;
  String? name;
  String? description;

  AlchemyNft({
    this.image,
    this.name,
    this.description,
  });

  factory AlchemyNft.fromJson(Map<String, dynamic> json) {
    debugPrint(json['metadata']['image']);
    return AlchemyNft(
      image: json['metadata']['image'] ?? '',
      name: json['metadata']['name'] ?? '',
      description: json['metadata']['description'] ?? '',
    );
  }
}
