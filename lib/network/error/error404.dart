import 'package:dio/dio.dart';
import 'package:moviereminder/network/error/error.dart';

import '../../helper/toast.dart';

class Error404 extends Error{
  @override
  void action(DioError error) {
    Toast.error(error.message);
  }

  @override
  int getCode() {
    return 404;
  }

}