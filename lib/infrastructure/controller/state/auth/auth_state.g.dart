// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthStateImpl _$$AuthStateImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      isAuthenticating: json['isAuthenticating'] as bool,
      isPremium: json['isPremium'] as bool,
    );

Map<String, dynamic> _$$AuthStateImplToJson(_$AuthStateImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'isAuthenticating': instance.isAuthenticating,
      'isPremium': instance.isPremium,
    };
