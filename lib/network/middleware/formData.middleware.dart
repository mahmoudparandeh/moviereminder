import 'package:dio/dio.dart';
import 'package:moviereminder/network/api_builder.dart';
import 'package:moviereminder/network/middleware/middleware.dart';

class FormDataMiddleware extends Middleware{
  @override
  void invoke(ApiBuilder apiBuilder) {
   apiBuilder.formData = FormData.fromMap(apiBuilder.body);
  }

}