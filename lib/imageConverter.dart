import 'dart:convert';
import 'dart:io';

Future<String?> imageToBase64(File? imageFile) async {
  if (imageFile == null) {
    return null;
  }
  List<int> bytes = await imageFile.readAsBytes();
  return base64Encode(bytes);
}


