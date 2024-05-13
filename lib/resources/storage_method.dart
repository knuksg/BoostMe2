import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Adding an image to Firebase Storage with detailed logging and error handling
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    print('🔓 Starting upload for $childName');
    try {
      // Prepare the storage reference.
      Reference ref =
          _storage.ref().child(childName).child(_auth.currentUser!.uid);
      print('📡 Storage reference created.');

      if (isPost) {
        String id = const Uuid().v1(); // Unique identifier for each post.
        ref = ref.child(id);
        print('🆔 New post ID generated: $id');
      }

      // Upload the image to Firebase.
      UploadTask uploadTask = ref.putData(file);
      print('🌐 Starting the upload task.');

      // Setting a timeout for the upload task.
      TaskSnapshot snapshot =
          await uploadTask.timeout(const Duration(minutes: 1), onTimeout: () {
        print('🕒 Upload task timed out.');
        throw FlutterError('Upload Task Timed Out');
      });

      // Check if the task is complete.
      if (snapshot.state == TaskState.success) {
        print('🖥️ Upload completed.');
      } else {
        print('🛑 Upload failed with state: ${snapshot.state}');
        throw FlutterError('Upload Failed');
      }

      // Get the downloadable URL.
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('🔗 Download URL retrieved: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      print('🔒 Error during upload: $e');
      throw FlutterError('Upload failed: $e');
    }
  }
}
