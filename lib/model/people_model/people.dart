import 'package:json_annotation/json_annotation.dart';
part 'people.g.dart';

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
