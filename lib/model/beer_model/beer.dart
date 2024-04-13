import 'package:json_annotation/json_annotation.dart';
part 'beer.g.dart';

List<BeerSummary> deserializeBeerSummaryList(List<Map<String, dynamic>> json) =>
    json.map((e) => BeerSummary.fromJson(e)).toList();

List<Map<String, dynamic>> serializeBeerSummaryList(List<BeerSummary> model) =>
    model.map((e) => e.toJson()).toList();

@JsonSerializable()
class BeerSummary {
  final int? id;
  final String? name;
  final String? description;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  BeerSummary({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
  });

  factory BeerSummary.fromJson(Map<String, dynamic> json) {
    return _$BeerSummaryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$BeerSummaryToJson(this);
  }
}
