// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_dev/common/constants.dart';
import 'package:flutter_stripe_dev/domain/entity/user/user.dart';
import 'package:flutter_stripe_dev/infrastructure/auth.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/account_controller.dart';
import 'package:flutter_stripe_dev/infrastructure/controller/payment_controller.dart';
import 'package:flutter_stripe_dev/infrastructure/functions/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class JoinPremiumView extends HookConsumerWidget {
  const JoinPremiumView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState<bool>(true);
    final user = ref.watch(accountNotifierProvider);
    final payment = ref.watch(paymentNotifierProvider);

    useEffect(() {
      Future<void> initilized() async {
        await ref.read(paymentNotifierProvider.notifier).initilized();
        await ref.read(accountNotifierProvider.notifier).initilized();
        isLoading.value = false;
      }

      initilized();
      return null;
    }, const []);

    if (isLoading.value) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () async {
                    await funcOneTimePayment(
                      context: context,
                      user: user,
                      amount: 5000,
                      ref: ref,
                    );
                    await IAuthRepository().getCustomClaims();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                payment[0].name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  Constants.strOneTimePurchaseLable,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '¥${payment[0].price.toString()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            'images/subscription_icon.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () async {
                    await funcSubscription(
                      context: context,
                      user: user,
                      priceId: payment[1].priceId,
                      ref: ref,
                    );
                    await IAuthRepository().getCustomClaims();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                payment[1].name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  Constants.strSubscriptionLable,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '¥${payment[1].price.toString()}/month',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            'images/one_time_purchase_icon.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> funcOneTimePayment({
    required BuildContext context,
    required User user,
    required int amount,
    required WidgetRef ref,
  }) async {
    try {
      final response = await ref
          .read(paymentNotifierProvider.notifier)
          .createPaymentIntent(
              uid: user.uid,
              email: user.email,
              username: user.username,
              amount: amount);
      final clientSecret = response['paymentIntent'];
      final ephemeralKey = response['ephemeralKey'];
      final customerId = response['customerId'];
      // 2. PaymentSheet を初期化
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: true,
          paymentIntentClientSecret: clientSecret,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customerId,
        ),
      );

      // 3. PaymentSheet を表示
      await Stripe.instance.presentPaymentSheet();

      // 4. 決済を確定
      await Stripe.instance.confirmPaymentSheetPayment();

      final PaymentIntent result =
          await Stripe.instance.retrievePaymentIntent(clientSecret);
      if (result.status.name.toString() == 'Succeeded') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment succeeded'),
          ),
        );
        await IAuthFunctionsRepository().updatePremiumPlan(uid: user.uid);
      }
    } on StripeException catch (e) {
      if (e.error.code.name == 'Canceled') {
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.error.localizedMessage}'),
          ),
        );
      }
    }
  }

  static Future<void> funcSubscription({
    required BuildContext context,
    required User user,
    required String priceId,
    required WidgetRef ref,
  }) async {
    try {
      final response = await ref
          .read(paymentNotifierProvider.notifier)
          .createSubscription(
              uid: user.uid,
              email: user.email,
              username: user.username,
              priceId: priceId);
      final clientSecret = response['paymentIntent'];
      final ephemeralKey = response['ephemeralKey'];
      final customerId = response['customerId'];
      // 2. PaymentSheet を初期化
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: true,
          paymentIntentClientSecret: clientSecret,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customerId,
        ),
      );

      // 3. PaymentSheet を表示
      await Stripe.instance.presentPaymentSheet();

      // 4. 決済を確定
      await Stripe.instance.confirmPaymentSheetPayment();
    } on StripeException catch (e) {
      if (e.error.code.name == 'Canceled') {
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.error.localizedMessage}'),
          ),
        );
      }
    }
  }
}
