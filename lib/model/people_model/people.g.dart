// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeopleModel _$PeopleModelFromJson(Map<String, dynamic> json) => PeopleModel(
      createdAt: json['createdAt'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$PeopleModelToJson(PeopleModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'name': instance.name,
      'avatar': instance.avatar,
      'id': instance.id,
    };
