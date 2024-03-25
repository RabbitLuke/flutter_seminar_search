import 'dart:convert';
import 'dart:io';

Future<String?> imageToBase64(File? imageFile) async {
  if (imageFile == null) {
    return null;
  }
  List<int> bytes = await imageFile.readAsBytes();
  return base64Encode(bytes);
}

// Method to convert base64 string to image file
File convertBase64ToImage(String base64String, String fileName) {
  // Decode the base64 string into bytes
  List<int> bytes = base64Decode(base64String);
  
  // Create a File object with the given fileName
  File file = File(fileName);

  // Write the bytes to the file
  file.writeAsBytesSync(bytes);

  return file;
}


