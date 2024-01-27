import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('Err: ${err.toString()}', name: "ERROR");
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(options.uri.toString(), name: "URL");
    log(encoder(options.headers), name: "REQUEST_HEADER");
    log(encoder(options.data), name: "REQUEST_BODY");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(response.statusCode.toString(), name: "RESPONSE_CODE");
    log(response.headers.toString(), name: "RESPONSE_HEADER");
    log(encoder(response.data), name: "RESPONSE_BODY");
    handler.next(response);
  }

  String encoder(dynamic value) {
    try {
      return JsonEncoder.withIndent(" " * 4).convert(value);
    } catch (e) {
      return value;
    }
  }
}
