import 'package:flutter/material.dart';
import 'package:flutter_stripe_dev/common/router/router_path.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/auth_controller.dart';
import 'package:flutter_stripe_dev/presentation/pages/account/account_view.dart';
import 'package:flutter_stripe_dev/presentation/pages/account/update/account_update_view.dart';
import 'package:flutter_stripe_dev/presentation/pages/auth/email_verified_view.dart';
import 'package:flutter_stripe_dev/presentation/pages/auth/sign_in_email_view.dart';
import 'package:flutter_stripe_dev/presentation/pages/auth/sign_up_email_view.dart';
import 'package:flutter_stripe_dev/presentation/pages/home/home_view.dart';
import 'package:flutter_stripe_dev/presentation/pages/payment/join_premium_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: RouterPath.home,
      routes: [
        // サインイン画面
        GoRoute(
          path: RouterPath.signIn,
          builder: (context, state) {
            return const SignInView();
          },
        ),
        // サインアップ画面
        GoRoute(
          path: RouterPath.signUp,
          builder: (context, state) {
            return const SignUpView();
          },
        ),
        // メールアドレス確認画面
        GoRoute(
          path: RouterPath.emailVerified,
          builder: (context, state) {
            return const EmailVerifiedView();
          },
        ),
        // ホーム画面
        GoRoute(
          path: RouterPath.home,
          builder: (context, state) {
            return const HomeView();
          },
          routes: [
            // アカウント画面
            GoRoute(
              path: RouterPath.account,
              builder: (context, state) {
                return const AccountView();
              },
              routes: [
                // アカウント更新画面
                GoRoute(
                  path: RouterPath.accountUpdate,
                  builder: (context, state) {
                    return const AccountUpdateView();
                  },
                ),
                // プレミアム加入画面
                GoRoute(
                  path: RouterPath.payment,
                  builder: (context, state) {
                    return const JoinPremiumView();
                  },
                ),
              ],
            ),
            // プレミアム加入画面
            GoRoute(
              path: RouterPath.payment,
              builder: (context, state) {
                return const JoinPremiumView();
              },
            ),
          ],
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) async {
        final isLoggedIn =
            await ref.read(authNotifierProvider.notifier).getLoggedInUser();
        // ログイン状態を取得（nullじゃない場合はログイン済み）
        final isAuth = isLoggedIn != null;

        // ログイン状態を取得
        if (!isAuth && state.fullPath != RouterPath.signIn) {
          return RouterPath.signUp;
        } else if (!isAuth && state.fullPath != RouterPath.signUp) {
          return RouterPath.signIn;
        } else if (isAuth && !isLoggedIn.emailVerified) {
          // ログイン済みかつメールアドレスが確認されていない場合は、メールアドレス確認画面に遷移
          return RouterPath.emailVerified;
        }

        final isState = state.fullPath == RouterPath.signIn ||
            state.fullPath == RouterPath.signUp;

        if (!isState) {
          return null;
        }
        return null;
      },
    );
  },
);
