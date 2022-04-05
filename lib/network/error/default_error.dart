import 'package:dio/dio.dart';
import 'package:moviereminder/network/error/error.dart';

import '../../helper/toast.dart';

class ErrorDefault extends Error{
  @override
  void action(DioError error) {
    Toast.error(error.message);
  }

  @override
  int getCode() {
    return 0;
  }

}