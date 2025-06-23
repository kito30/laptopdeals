import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final storage = FirebaseStorage.instance;

Future<String> uploadImage(File? image) async {
  if (image == null) {
    return '';
  }

  try {
    // Generate a unique file name
    String fileName =
        DateTime.now().millisecondsSinceEpoch.toString() +
        image.path.split('/').last;

    // Create a reference to the folder and file
    final storageRef = storage.ref().child('laptopimage/$fileName');

    // Upload the file
    final uploadTask = await storageRef.putFile(image);

    // Get the download URL
    return await uploadTask.ref.getDownloadURL();
  } catch (e) {
    throw Exception('Failed to upload image: $e');
  }
}
