import 'package:flutter_stripe_dev/domain/entity/products/products.dart';
import 'package:flutter_stripe_dev/domain/repository/functions/payment.dart';
import 'package:flutter_stripe_dev/infrastructure/functions/payment.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaymentNotifier extends StateNotifier<List<Products>> {
  PaymentNotifier({
    required this.paymentFunctionsRepository,
    required this.ref,
  }) : super([]);

  final PaymentFunctionsReposiroty paymentFunctionsRepository;
  final Ref ref;

  Future<void> initilized() async {
    final response = await paymentFunctionsRepository.getPayment();
    state = response;
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      {required String uid,
      required String email,
      required String username,
      required int amount}) async {
    final response = await paymentFunctionsRepository.createPaymentIntent(
      uid: uid,
      email: email,
      username: username,
      amount: amount,
    );
    return response;
  }

  Future<Map<String, dynamic>> createSubscription(
      {required String uid,
      required String email,
      required String username,
      required String priceId}) async {
    final response = await paymentFunctionsRepository.createSubscription(
      uid: uid,
      email: email,
      username: username,
      priceId: priceId,
    );
    return response;
  }
}

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, List<Products>>(
  (ref) => PaymentNotifier(
    paymentFunctionsRepository: ref.watch(paymentFunctionsRepositoryProvider),
    ref: ref,
  ),
);
