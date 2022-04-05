import 'package:dio/dio.dart';
import 'package:moviereminder/network/methods/method.dart';

class DeleteMethod extends Method{
  static final DeleteMethod _instance = DeleteMethod._internal();

  factory DeleteMethod() {
    return _instance;
  }

  DeleteMethod._internal();

  @override
  action({required Dio httpClient, required String route, required Options options, dynamic data}){
    return httpClient.delete(route, options: options, data: data);
  }
}