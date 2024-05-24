import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signInWithEmail(
      {required String email, required String password});

  Future<String> signUpWithEmail(
      {required String email, required String password});

  Future<void> signOut();

  Future<bool> getCustomClaims();

  Future<User?> getLoggedInUser();

  Future<User?> getLoggedInUserWithEmailVerification();

  Future<void> sendEmailVerification();
}
