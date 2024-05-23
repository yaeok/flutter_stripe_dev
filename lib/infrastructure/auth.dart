import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe_dev/domain/repository/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IAuthRepository extends AuthRepository {
  final auth = FirebaseAuth.instance;

  @override
  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            throw 'user-not-found';
          case 'wrong-password':
            throw 'wrong-password';
          default:
            throw 'system-error';
        }
      }
    }
  }

  @override
  Future<String> signUpWithEmail(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user!.emailVerified == false) {
        await sendEmailVerification();
      }
      return userCredential.user!.uid;
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            throw 'email-already-in-use';
          case 'weak-password':
            throw 'weak-password';
          default:
            throw 'system-error';
        }
      } else {
        throw 'system-error';
      }
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<bool> getCustomClaims() async {
    final user = auth.currentUser;
    try {
      final idTokenResult = await user!.getIdTokenResult();
      if (idTokenResult.claims!['premium'] as bool) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Firebase Authのユーザー情報を取得
  @override
  Future<User?> getLoggedInUser() async {
    try {
      await auth.currentUser?.reload();
      final User? authUser = auth.currentUser;
      if (authUser == null) {
        return null;
      }
      return authUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final User? user = auth.currentUser;
      await user?.sendEmailVerification();
    } catch (e) {
      throw 'system-error';
    }
  }
}

final authRepositoryProvider = Provider<IAuthRepository>(
  (ref) => IAuthRepository(),
);
