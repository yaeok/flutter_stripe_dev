// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/account_controller.dart';
import 'package:flutter_stripe_dev/presentation/widgets/round_rect_button.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountUpdateView extends HookConsumerWidget {
  const AccountUpdateView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameFormKey =
        useMemoized(() => GlobalKey<FormBuilderState>(), []);

    FocusScopeNode currentFocus = FocusScope.of(context);

    final isUsernameFormValid = useState<bool>(false);

    final isFormValid = isUsernameFormValid.value;

    void updateUsernameFormValidity() {
      final usernameValid = usernameFormKey.currentState?.validate() ?? false;
      isUsernameFormValid.value = usernameValid;
    }

    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 40),
                FormBuilder(
                  key: usernameFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          'Username',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'username',
                        cursorColor: Colors.lightBlueAccent,
                        keyboardType: TextInputType.multiline,
                        onChanged: (_) => updateUsernameFormValidity(),
                        decoration: const InputDecoration(
                          hintText: 'ユーザネーム',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
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
                            FormBuilderValidators.maxLength(20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      RoundRectButton(
                        label: 'ユーザ情報更新',
                        onPressed: () async {
                          try {
                            await ref
                                .read(accountNotifierProvider.notifier)
                                .updateProfile(
                                    username: usernameFormKey.currentState!
                                        .fields['username']!.value)
                                .then(
                                  (_) => context.pop(),
                                );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                              ),
                            );
                          }
                        },
                        isDisabled: !isFormValid,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
