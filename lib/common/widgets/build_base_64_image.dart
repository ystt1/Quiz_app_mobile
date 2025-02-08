import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Base64ImageWidget extends StatelessWidget {
  final String? base64String;

  const Base64ImageWidget({super.key, this.base64String});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;


    try {
      if (base64String != null && base64String!.isNotEmpty) {
        imageBytes = base64Decode(base64String!);
      }
    } catch (e) {
      imageBytes = null;
    }

    if (imageBytes != null) {
      return Image.memory(
        imageBytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildNetworkOrAssetImage();
        },
      );
    } else {
      return _buildNetworkOrAssetImage();
    }
  }

  Widget _buildNetworkOrAssetImage() {
    if (base64String != null &&
        base64String!.isNotEmpty &&
        (base64String!.startsWith('http://') || base64String!.startsWith('https://'))) {
      return Image.network(
        base64String!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/img/basic_quiz_image.jpg', fit: BoxFit.cover);
        },
      );
    } else {
      return Image.asset('assets/img/basic_quiz_image.jpg', fit: BoxFit.cover);
    }
  }
}