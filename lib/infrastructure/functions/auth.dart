import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe_dev/domain/repository/functions/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IAuthFunctionsRepository extends AuthFunctionsRepository {
  // cloud functions
  final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast1');

  @override
  Future<void> updatePremiumPlan({required String uid}) async {
    final func = functions.httpsCallable('updatePremiumPlan');
    await func.call({'uid': uid});
  }
}

final authFunctionsRepositoryProvider = Provider(
  (ref) => IAuthFunctionsRepository(),
);
