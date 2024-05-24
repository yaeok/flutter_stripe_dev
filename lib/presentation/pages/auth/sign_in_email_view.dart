// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe_dev/common/router/router_path.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/auth_controller.dart';
import 'package:flutter_stripe_dev/presentation/widgets/round_rect_button.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInView extends HookConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailFormKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);
    final passwordFormKey =
        useMemoized(() => GlobalKey<FormBuilderState>(), []);

    FocusScopeNode currentFocus = FocusScope.of(context);

    final isEmailFormValid = useState<bool>(false);
    final isPasswordFormValid = useState<bool>(false);

    final isObscure = useState<bool>(true);

    final isFormValid = isEmailFormValid.value && isPasswordFormValid.value;

    void updateEmailFormValidity() {
      final emailValid = emailFormKey.currentState?.validate() ?? false;
      isEmailFormValid.value = emailValid;
    }

    void updatePasswordFormValidity() {
      final passwordValid = passwordFormKey.currentState?.validate() ?? false;
      isPasswordFormValid.value = passwordValid;
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  const Text(
                    'ログイン',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
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
                  FormBuilder(
                    key: passwordFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FormBuilderTextField(
                          name: 'password',
                          cursorColor: Colors.amber,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isObscure.value,
                          onChanged: (_) => updatePasswordFormValidity(),
                          decoration: InputDecoration(
                            hintText: 'パスワード',
                            fillColor: Colors.white,
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(isObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                isObscure.value = !isObscure.value;
                              },
                              color: Colors.green,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.amber,
                                width: 4,
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 4,
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 4,
                              ),
                            ),
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                errorText: '入力してください',
                              ),
                              FormBuilderValidators.minLength(
                                8,
                                errorText: '8文字以上で入力してください',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  RoundRectButton(
                    label: 'ログイン',
                    onPressed: () async {
                      try {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signInWithEmail(
                                email: emailFormKey
                                    .currentState!.fields['email']!.value,
                                password: passwordFormKey
                                    .currentState!.fields['password']!.value)
                            .then(
                              (_) => context.go(RouterPath.homeRoute),
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
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      context.go(RouterPath.signUpRoute);
                    },
                    child: const Text(
                      'まだアカウントをお持ちでない方はこちら',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
