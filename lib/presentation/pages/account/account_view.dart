// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe_dev/common/router/router_path.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/account_controller.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/auth_controller.dart';
import 'package:flutter_stripe_dev/presentation/pages/account/widgets/confirm_dialog.dart';
import 'package:flutter_stripe_dev/presentation/pages/account/widgets/container_bar.dart';
import 'package:flutter_stripe_dev/presentation/widgets/toast.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AccountView extends HookConsumerWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(accountNotifierProvider);
    final auth = ref.watch(authNotifierProvider);
    final isLoading = useState<bool>(true);
    final picker = ImagePicker();
    useEffect(() {
      Future<void> initilized() async {
        await ref.read(accountNotifierProvider.notifier).initilized();
        isLoading.value = false;
      }

      initilized();
      return null;
    }, const []);

    // ローディング中
    if (isLoading.value) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      final image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image == null) {
                        return;
                      }
                      isLoading.value = true;
                      await ref
                          .read(accountNotifierProvider.notifier)
                          .uploadImage(image: image);
                      isLoading.value = false;
                    },
                    child: user.imageURL.isNotEmpty
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(user.imageURL),
                          )
                        : const CircleAvatar(
                            radius: 60,
                          ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ユーザー名',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'メールアドレス',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ContainerBar(
                  label: 'プレミアムに加入する',
                  onTap: () {
                    if (auth.isPremium) {
                      showToast(
                        message: 'すでに加入しています',
                        fontSize: 16,
                      );
                      return;
                    }
                    context.go(RouterPath.paymentRouteFromAccount);
                  },
                ),
                ContainerBar(
                  label: 'アカウント情報更新',
                  onTap: () {
                    context.go(RouterPath.accountUpdateRoute);
                  },
                ),
                ContainerBar(
                  label: '開発者へお問い合わせ',
                  onTap: () {},
                ),
                ContainerBar(
                  label: '利用規約',
                  onTap: () {},
                ),
                ContainerBar(
                  label: 'プライバシーポリシー',
                  onTap: () {},
                ),
                ContainerBar(
                  label: '退会する',
                  onTap: () {
                    showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'アカウントを削除しますか？\nアカウントを削除すると、\nデータは全て削除されます。',
                        onYes: () {
                          ref
                              .read(authNotifierProvider.notifier)
                              .deleteAuthUser();
                        },
                        onNo: () {
                          Navigator.of(context).pop();
                        },
                        isEmphasisEnabled: true,
                        emphasizedWord: 'この操作は取り消せません。',
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
