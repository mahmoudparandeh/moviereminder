import 'package:dio/dio.dart';

class DioClient {
  factory DioClient() {
    return _dioClient;
  }

  DioClient._internal();

  static final DioClient _dioClient = DioClient._internal();
  final Dio _dio = Dio();

  Dio get dio => _dio;
}