// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe_dev/common/router/router_path.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/auth_controller.dart';
import 'package:flutter_stripe_dev/presentation/widgets/round_rect_button.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmailVerifiedView extends HookConsumerWidget {
  const EmailVerifiedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailFormKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);

    FocusScopeNode currentFocus = FocusScope.of(context);

    final isEmailFormValid = useState<bool>(false);

    final isFormValid = isEmailFormValid.value;

    void updateEmailFormValidity() {
      final emailValid = emailFormKey.currentState?.validate() ?? false;
      isEmailFormValid.value = emailValid;
    }

    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('まだメール認証が完了していません'),
                const Text('再送する場合、下記のボタンを押してください'),
                FormBuilder(
                  key: emailFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'email',
                        cursorColor: Colors.amber,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => updateEmailFormValidity(),
                        decoration: const InputDecoration(
                          hintText: 'メールアドレス',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.amber,
                              width: 4,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 4,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 4,
                            ),
                          ),
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: '入力してください'),
                            FormBuilderValidators.email(
                                errorText: 'メールの形式が正しくありません'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                RoundRectButton(
                  label: '再送する',
                  onPressed: () {
                    ref
                        .read(authNotifierProvider.notifier)
                        .sendEmailVerification();
                  },
                  isDisabled: !isFormValid,
                ),
                const SizedBox(height: 8),
                RoundRectButton(
                  label: 'ホームへ',
                  onPressed: () async {
                    final user = await ref
                        .read(authNotifierProvider.notifier)
                        .getLoggedInUserWithEmailVerification();
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('メール認証が完了していません'),
                        ),
                      );
                      return;
                    }
                    context.go(RouterPath.homeRoute);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
