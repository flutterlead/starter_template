import 'package:json_annotation/json_annotation.dart';

part 'people.g.dart';

List<PeopleModel> deserializePeopleModelList(List<Map<String, dynamic>> json) =>
    json.map((e) => PeopleModel.fromJson(e)).toList();

List<Map<String, dynamic>> serializePeopleModelList(List<PeopleModel> model) =>
    model.map((e) => e.toJson()).toList();

@JsonSerializable()
class PeopleModel {
  String? createdAt;
  String? name;
  String? avatar;
  String? id;

  PeopleModel({
    this.createdAt,
    this.name,
    this.avatar,
    this.id,
  });

  factory PeopleModel.fromJson(Map<String, dynamic> json) {
    return _$PeopleModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PeopleModelToJson(this);
  }
}
