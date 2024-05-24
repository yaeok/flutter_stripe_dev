import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe_dev/domain/repository/auth.dart';
import 'package:flutter_stripe_dev/domain/repository/functions/auth.dart';
import 'package:flutter_stripe_dev/domain/repository/user.dart';
import 'package:flutter_stripe_dev/infrastructure/auth.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/state/auth/auth_state.dart';
import 'package:flutter_stripe_dev/infrastructure/functions/auth.dart';
import 'package:flutter_stripe_dev/infrastructure/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.authRepository,
    required this.authFunctionsRepository,
    required this.userRepository,
  }) : super(
          const AuthState(
            uid: '',
            email: '',
            isAuthenticating: false,
            isPremium: false,
          ),
        );

  final AuthRepository authRepository;
  final AuthFunctionsRepository authFunctionsRepository;
  final UserRepository userRepository;
  final auth = FirebaseAuth.instance;

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    try {
      await authRepository.signInWithEmail(email: email, password: password);

      state = AuthState(
        uid: auth.currentUser!.uid,
        email: auth.currentUser!.email!,
        isAuthenticating: true,
        isPremium: false,
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

  Future<void> signUpWithEmail(
      {required String email, required String password}) async {
    try {
      String uid = await authRepository.signUpWithEmail(
          email: email, password: password);
      if (uid.isNotEmpty) {
        await userRepository.registerUser(uid: uid, email: email);
        state = AuthState(
          uid: uid,
          email: email,
          isAuthenticating: true,
          isPremium: false,
        );
      } else {
        throw 'system-error';
      }
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

  Future<void> sendEmailVerification() async {
    await authRepository.sendEmailVerification();
  }

  Future<void> signOut() async {
    await auth.signOut();
    state = const AuthState(
      uid: '',
      email: '',
      isAuthenticating: false,
      isPremium: false,
    );
  }

  Future<User?> getLoggedInUser() async {
    final user = await authRepository.getLoggedInUser();
    final isPremium = await authRepository.getCustomClaims();
    if (user != null) {
      state = state.copyWith(
        uid: user.uid,
        email: user.email!,
        isAuthenticating: true,
        isPremium: isPremium,
      );
      return user;
    }
    return null;
  }

  Future<User?> getLoggedInUserWithEmailVerification() async {
    final user = await authRepository.getLoggedInUserWithEmailVerification();
    final isPremium = await authRepository.getCustomClaims();
    if (user != null) {
      state = state.copyWith(
        uid: user.uid,
        email: user.email!,
        isAuthenticating: true,
        isPremium: isPremium,
      );
      return user;
    }
    return null;
  }

  Future<void> updatePremiumPlan() async {
    try {
      final uid = auth.currentUser!.uid;
      await authFunctionsRepository.updatePremiumPlan(uid: uid);
      final isPremium = await authRepository.getCustomClaims();
      state = state.copyWith(isPremium: isPremium);
    } catch (e) {
      throw 'system-error';
    }
  }

  Future<void> deleteAuthUser() async {
    try {
      await authRepository.deleteAuthUser();
      state = const AuthState(
        uid: '',
        email: '',
        isAuthenticating: false,
        isPremium: false,
      );
    } catch (e) {
      throw 'system-error';
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    authRepository: ref.watch(authRepositoryProvider),
    authFunctionsRepository: ref.watch(authFunctionsRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  ),
);
