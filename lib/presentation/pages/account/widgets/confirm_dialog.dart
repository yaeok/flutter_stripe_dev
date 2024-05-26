import 'package:flutter/material.dart';
import 'package:flutter_stripe_dev/presentation/widgets/base_dialog.dart';
import 'package:flutter_stripe_dev/presentation/widgets/outline_round_rect_button.dart';
import 'package:flutter_stripe_dev/presentation/widgets/round_rect_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfirmDialog extends HookConsumerWidget {
  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.onYes,
    required this.onNo,
    this.emphasizedWord,
    required this.isEmphasisEnabled,
  }) : super(key: key);

  final String title;
  final VoidCallback onYes;
  final VoidCallback onNo;
  final String? emphasizedWord;
  final bool isEmphasisEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseDialog(
      widget: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            isEmphasisEnabled
                ? const Text(
                    'この操作は取り消せません。',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RoundRectButton(
                    label: 'はい',
                    onPressed: onYes,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlineRoundRectButton(
                    label: 'いいえ',
                    onPressed: onNo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
