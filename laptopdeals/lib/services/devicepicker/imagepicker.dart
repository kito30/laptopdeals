import 'package:image_picker/image_picker.dart';
import 'dart:io';

final ImagePicker _imagePicker = ImagePicker();

Future<File?> pickImageFromGallery() async {
  final pickedFile = await _imagePicker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 800,
    maxHeight: 600,
  );

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null; // User cancelled the selection
}
