// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeerSummary _$BeerSummaryFromJson(Map<String, dynamic> json) => BeerSummary(
      id: json['id'] as int?,
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$BeerSummaryToJson(BeerSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
    };
