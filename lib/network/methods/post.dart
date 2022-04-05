import 'package:dio/dio.dart';
import 'package:moviereminder/network/methods/method.dart';

class PostMethod extends Method{
  static final PostMethod _instance = PostMethod._internal();

  factory PostMethod() {
    return _instance;
  }

  PostMethod._internal();
  @override
  action({required Dio httpClient, required String route, required Options options, dynamic data}) {
    return httpClient.post(route, options: options, data: data);
  }
}