import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';


Future<String> convertImageToBase64(XFile image) async {

  final File imageFile = File(image.path);
  final bytes = await imageFile.readAsBytes();
  return base64Encode(bytes);
}