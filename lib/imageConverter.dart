import 'dart:convert';
import 'dart:io';

Future<String?> imageToBase64(File? imageFile) async {
  if (imageFile == null) {
    return null;
  }
  List<int> bytes = await imageFile.readAsBytes();
  return base64Encode(bytes);
}

File convertBase64ToImage(String base64String, String fileName) {
  List<int> bytes = base64Decode(base64String);
  File file = File(fileName);
  file.writeAsBytesSync(bytes);

  return file;
}


