import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_stripe_dev/domain/entity/user/user.dart';
import 'package:flutter_stripe_dev/domain/repository/user.dart';
import 'package:flutter_stripe_dev/infrastructure/firestore/firestore.dart';
import 'package:flutter_stripe_dev/infrastructure/utils/image_compressor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IUserRepository extends UserRepository {
  final userDB = Firestore.users;
  final stotage = FirebaseStorage.instance;

  @override
  Future<void> registerUser(
      {required String uid, required String email}) async {
    try {
      await userDB.doc(uid).set({
        'uid': uid,
        'email': email,
        'username': email.substring(0, email.indexOf('@')),
        'imageURL': '',
      });
    } catch (e) {
      throw 'system-error';
    }
  }

  @override
  Future<User> getUserByUid({required String uid}) async {
    return await userDB.doc(uid).get().then((value) {
      return User.fromJson(value.data()!);
    });
  }

  @override
  Future<void> updateUser({required User user}) async {
    try {
      await userDB.doc(user.uid).update(user.toJson());
    } catch (e) {
      throw 'system-error';
    }
  }

  @override
  Future<String> uploadImage(
      {required XFile image, required String userId}) async {
    try {
      final fileName = image.name;
      final data = await ImageCompressor().compress(
        File(image.path).readAsBytesSync(),
        1 * 1024 * 1024,
      );
      final storageRef = stotage.ref().child('profile_images/$fileName');
      await storageRef.putData(data);
      final imageUrl = await storageRef.getDownloadURL();
      final userDoc = Firestore.users.doc(userId);
      await userDoc.update({'imageURL': imageUrl});

      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image$e');
    }
  }
}

final userRepositoryProvider = Provider<IUserRepository>(
  (ref) => IUserRepository(),
);
