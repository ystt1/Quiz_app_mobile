import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

Future<String?> getImgString() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? _pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (_pickedFile != null) {
    File file = File(_pickedFile.path);


    List<int> imageBytes = file.readAsBytesSync();


    img.Image? originalImage = img.decodeImage(Uint8List.fromList(imageBytes));
    if (originalImage == null) return null;


    img.Image resizedImage = img.copyResize(originalImage, width: 800);

    // Chuyển đổi ảnh thành Uint8List (JPG, quality 70)
    Uint8List resizedBytes = Uint8List.fromList(img.encodeJpg(resizedImage, quality: 50));

    // Chuyển sang Base64
    String base64String = base64Encode(resizedBytes);
    return base64String;
  } else {
    return null;
  }
}
