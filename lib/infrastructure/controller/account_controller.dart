import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
            imageURL: '',
          ),
        );

  final UserRepository userRepository;
  final auth = firebase.FirebaseAuth.instance;

  Future<void> initilized() async {
    final uid = auth.currentUser!.uid;
    final user = await userRepository.getUserByUid(uid: uid);
    state = user;
  }

  Future<String?> uploadImage({required XFile image}) async {
    try {
      final uid = auth.currentUser!.uid;
      final imageUrl =
          await userRepository.uploadImage(image: image, userId: uid);
      state = state.copyWith(imageURL: imageUrl);
      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfile({required String? username, String? email}) async {
    final user = User(
      uid: state.uid,
      username: username ?? state.username,
      email: email ?? state.email,
      imageURL: state.imageURL,
    );
    try {
      await userRepository.updateProfile(user: user);
      state = user;
    } catch (e) {
      throw 'system-error';
    }
  }
}

final accountNotifierProvider = StateNotifierProvider<AccountNotifier, User>(
  (ref) => AccountNotifier(
    userRepository: ref.watch(userRepositoryProvider),
  ),
);
