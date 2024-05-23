import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_stripe_dev/domain/entity/user/user.dart';
import 'package:flutter_stripe_dev/domain/repository/user.dart';
import 'package:flutter_stripe_dev/infrastructure/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountNotifier extends StateNotifier<User> {
  AccountNotifier({
    required this.userRepository,
  }) : super(
          const User(
            uid: '',
            username: '',
            email: '',
          ),
        );

  final UserRepository userRepository;
  final auth = firebase.FirebaseAuth.instance;

  Future<void> initilized() async {
    final uid = auth.currentUser!.uid;
    final user = await userRepository.getUserByUid(uid: uid);
    state = user;
  }
}

final accountNotifierProvider = StateNotifierProvider<AccountNotifier, User>(
  (ref) => AccountNotifier(
    userRepository: ref.watch(userRepositoryProvider),
  ),
);
