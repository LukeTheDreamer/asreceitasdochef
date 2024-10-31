import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:receitas_do_chef/exceptions_sys.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, {Map<String, String>? customMetadata}) async {
    try {
      // Generate a unique file name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(file.path);
      final fileName = 'image_$timestamp$extension';

      // Create reference
      final storageRef = _storage.ref().child('images/$fileName');

      // Create metadata if provided
      SettableMetadata? metadata;
      if (customMetadata != null) {
        metadata = SettableMetadata(
          contentType: 'image/${extension.substring(1)}',
          customMetadata: customMetadata,
        );
      }

      // Upload file
      await storageRef.putFile(file, metadata);

      // Get download URL
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw StorageException(
        'Error uploading image: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw StorageException('Unexpected error uploading image');
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw StorageException(
        'Error deleting image: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw StorageException('Unexpected error deleting image');
    }
  }
}

class StorageException extends AppException {
  StorageException(super.message, {super.code});
}