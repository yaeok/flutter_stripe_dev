import 'package:flutter_stripe_dev/domain/entity/user/user.dart';
import 'package:flutter_stripe_dev/domain/repository/user.dart';
import 'package:flutter_stripe_dev/infrastructure/firestore/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IUserRepository extends UserRepository {
  final userDB = Firestore.users;

  @override
  Future<void> regUser({required String uid, required String email}) async {
    try {
      await userDB.doc(uid).set({
        'uid': uid,
        'email': email,
        'username': email.substring(0, email.indexOf('@')),
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
}

final userRepositoryProvider = Provider<IUserRepository>(
  (ref) => IUserRepository(),
);
