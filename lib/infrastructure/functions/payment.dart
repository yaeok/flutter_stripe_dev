import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe_dev/domain/entity/products/products.dart';
import 'package:flutter_stripe_dev/domain/repository/functions/payment.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IPaymentFunctionsRepository extends PaymentFunctionsReposiroty {
  // cloud functions
  final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast1');

  @override
  Future<List<Products>> getPayment() async {
    try {
      final func = functions.httpsCallable('getAllProducts');
      final response = await func.call();
      final products = response.data as List<dynamic>;
      final List<Products> productsList = [];
      for (final product in products) {
        productsList.add(Products.fromJson(product));
      }
      return productsList;
    } catch (e) {
      throw 'system-error';
    }
  }

  @override
  Future<Map<String, dynamic>> createPaymentIntent({
    required String uid,
    required String email,
    required String username,
    required int amount,
  }) async {
    try {
      final func = functions.httpsCallable('createPaymentIntent');
      final response = await func.call(
        {'uid': uid, 'email': email, 'username': username, 'amount': amount},
      );
      return {
        'paymentIntent': response.data['paymentIntent'],
        'ephemeralKey': response.data['ephemeralKey'],
        'customerId': response.data['customerId'],
      };
    } catch (e) {
      throw 'system-error';
    }
  }

  @override
  Future<Map<String, dynamic>> createSubscription({
    required String uid,
    required String email,
    required String username,
    required String priceId,
  }) async {
    try {
      final func = functions.httpsCallable('createSubscription');
      final response = await func.call(
        {'uid': uid, 'email': email, 'username': username, 'priceId': priceId},
      );
      return {
        'paymentIntent': response.data['paymentIntent'],
        'ephemeralKey': response.data['ephemeralKey'],
        'customerId': response.data['customerId'],
      };
    } catch (e) {
      throw 'system-error';
    }
  }
}

final paymentFunctionsRepositoryProvider = Provider(
  (ref) => IPaymentFunctionsRepository(),
);
