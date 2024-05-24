import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signInWithEmail(
      {required String email, required String password});
  Future<String> signUpWithEmail(
      {required String email, required String password});
  Future<User?> getLoggedInUserWithEmailVerification();
  Future<void> sendEmailVerification();
  Future<User?> getLoggedInUser();
  Future<bool> getCustomClaims();
  Future<void> deleteAuthUser();
  Future<void> signOut();
}
