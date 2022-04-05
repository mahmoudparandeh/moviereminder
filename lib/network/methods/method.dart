import 'package:dio/dio.dart';
abstract class Method{
  Future<Response<dynamic>> action({
    required Dio httpClient,
    required String route,
    required Options options,
    dynamic data,
  });
}