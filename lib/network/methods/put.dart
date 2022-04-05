import 'package:dio/dio.dart';
import 'package:moviereminder/network/methods/method.dart';

class PutMethod extends Method{
  static final PutMethod _instance = PutMethod._internal();

  factory PutMethod() {
    return _instance;
  }

  PutMethod._internal();

  @override
  action({required Dio httpClient, required String route, required Options options, dynamic data}) {
    return httpClient.put(route, options: options, data: data);
  }
}