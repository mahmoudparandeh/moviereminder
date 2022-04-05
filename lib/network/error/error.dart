import 'package:dio/dio.dart';

abstract class Error{
  int getCode();
  void action(DioError error);
}