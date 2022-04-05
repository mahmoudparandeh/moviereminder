import 'package:dio/dio.dart';
import 'package:moviereminder/network/error/error.dart';

import '../../helper/toast.dart';

class Error403 extends Error{
  @override
  void action(DioError error) {
    Toast.error(error.message);
  }

  @override
  int getCode() {
    return 403;
  }

}