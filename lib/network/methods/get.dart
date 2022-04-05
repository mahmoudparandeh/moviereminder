import 'package:dio/dio.dart';
import 'package:moviereminder/network/methods/method.dart';

class GetMethod extends Method{
  static final GetMethod _instance = GetMethod._internal();

  factory GetMethod() {
    return _instance;
  }

  GetMethod._internal();
  @override
  action({required Dio httpClient, required String route, required Options options, dynamic data}) {
    return httpClient.get(route, options: options);
  }
}