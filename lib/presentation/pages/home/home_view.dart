// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_stripe_dev/common/router/router_path.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/auth_controller.dart';
import 'package:flutter_stripe_dev/presentation/widgets/round_rect_button.dart';
import 'package:flutter_stripe_dev/presentation/widgets/toast.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.go(RouterPath.accountRoute);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: RoundRectButton(
              label: 'プレミアム加入',
              onPressed: () {
                if (user.isPremium) {
                  showToast(
                    message: 'すでに加入しています',
                    fontSize: 16,
                  );
                  return;
                }
                context.go(RouterPath.paymentRouteFromHome);
              },
              isDisabled: false,
            ),
          ),
        ],
      ),
    );
  }
}
