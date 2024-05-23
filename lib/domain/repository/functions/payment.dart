import 'package:flutter_stripe_dev/domain/entity/products/products.dart';

abstract class PaymentFunctionsReposiroty {
  // 支払い情報の取得
  Future<List<Products>> getPayment();

  // 単発決済支払い情報の作成
  Future<Map<String, dynamic>> createPaymentIntent(
      {required String uid,
      required String email,
      required String username,
      required int amount});

  // サブスクリプション支払い情報の作成
  Future<Map<String, dynamic>> createSubscription(
      {required String uid,
      required String email,
      required String username,
      required String priceId});
}
