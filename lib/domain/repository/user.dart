import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_stripe_dev/domain/entity/user/user.dart';

abstract class UserRepository {
  Future<void> registerUser({required String uid, required String email});
  Future<User> getUserByUid({required String uid});
  Future<void> updateUser({required User user});
  Future<String> uploadImage({required XFile image, required String userId});
}
