import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/http.dart';
import 'package:starter_template/model/people_model/people.dart';
import 'package:injectable/injectable.dart' as i;


part 'api_service.g.dart';

@RestApi(
  baseUrl: "https://61028c7079ed68001748216c.mockapi.io/",
  parser: Parser.FlutterCompute,
)
@i.lazySingleton
@i.injectable
abstract class RestClient {
  @i.factoryMethod
  factory RestClient(Dio dio) = _RestClient;

  @GET("/peoples")
  Future<List<PeopleModel>> getPeoples();

}

List<PeopleModel> deserializePeopleModelList(List<Map<String, dynamic>> json) => json.map((e) => PeopleModel.fromJson(e)).toList();


