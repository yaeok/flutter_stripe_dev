import 'package:freezed_annotation/freezed_annotation.dart';

part 'products.freezed.dart';
part 'products.g.dart';

@freezed
class Products with _$Products {
  // プロパティ
  const factory Products({
    required String productId,
    required String name,
    required String priceId,
    required bool isSubscribed,
    required int price,
  }) = _Products;

  factory Products.fromJson(Map<dynamic, dynamic> json) =>
      _$ProductsFromJson(json);
}
