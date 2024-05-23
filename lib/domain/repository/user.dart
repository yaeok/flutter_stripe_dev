import 'package:flutter_stripe_dev/domain/entity/user/user.dart';

abstract class UserRepository {
  Future<void> regUser({required String uid, required String email});
  Future<User> getUserByUid({required String uid});
}
