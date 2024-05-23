// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductsImpl _$$ProductsImplFromJson(Map<dynamic, dynamic> json) =>
    _$ProductsImpl(
      productId: json['productId'] as String,
      name: json['name'] as String,
      priceId: json['priceId'] as String,
      isSubscribed: json['isSubscribed'] as bool,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductsImplToJson(_$ProductsImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'priceId': instance.priceId,
      'isSubscribed': instance.isSubscribed,
      'price': instance.price,
    };
