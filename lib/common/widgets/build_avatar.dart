import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Widget buildAvatar(String? base64String,{int? Size=20}) {
  Uint8List? imageBytes;

  try {
    if (base64String != null && base64String.isNotEmpty) {
      imageBytes = base64Decode(base64String);
    }
  } catch (e) {
    imageBytes = null;
  }

  return CircleAvatar(
    backgroundColor: Colors.grey[300],
    radius: Size?.toDouble()??20,
    child: imageBytes != null
        ? ImageIcon(MemoryImage(imageBytes))
        : const Icon(Icons.person, color: Colors.grey),
  );
}
