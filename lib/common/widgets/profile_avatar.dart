import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget profileAvatar(String? base64String) {
  Uint8List? imageBytes;

  try {
    if (base64String != null && base64String.isNotEmpty) {
      imageBytes = base64Decode(base64String);
    }
  } catch (e) {
    imageBytes = null;
  }

  return Material(
    color: Colors.transparent, // Cho phép nhận sự kiện touch
    child: CircleAvatar(
      backgroundColor: Colors.grey[300],
      radius: 60,
      backgroundImage: imageBytes != null ? MemoryImage(imageBytes) : null,
      child: imageBytes == null ? const Icon(Icons.person, color: Colors.grey) : null,
    ),
  );
}
