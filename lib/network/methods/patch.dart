import 'package:dio/dio.dart';
import 'package:moviereminder/network/methods/method.dart';

class PatchMethod extends Method{
  static final PatchMethod _instance = PatchMethod._internal();

  factory PatchMethod() {
    return _instance;
  }

  PatchMethod._internal();
  @override
  action({required Dio httpClient, required String route, required Options options, dynamic data}) {
    return httpClient.patch(route, options: options, data: data);
  }
}