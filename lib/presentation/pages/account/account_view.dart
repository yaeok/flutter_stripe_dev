// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_stripe_dev/common/router/router_path.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/auth_controller.dart';
import 'package:flutter_stripe_dev/presentation/pages/account/widgets/confirm_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountView extends HookConsumerWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              showDialog<bool>(
                context: context,
                builder: (context) => ConfirmDialog(
                  title: 'アプリから\nログアウトしますか？',
                  onYes: () {
                    ref.read(authNotifierProvider.notifier).signOut();
                    context.go(RouterPath.signInRoute);
                  },
                  onNo: () {
                    Navigator.of(context).pop();
                  },
                  isEmphasisEnabled: false,
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
