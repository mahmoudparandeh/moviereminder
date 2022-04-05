import 'package:dio/dio.dart';
import 'package:moviereminder/network/error/error.dart';

import '../../helper/toast.dart';

class Error422 extends Error{
  @override
  void action(DioError error) {
    if (error.response?.data != null && error.response?.data["data"] != null) {
      String message = '';
      error.response?.data["data"].forEach((value) {
        if (value != null && value.containsKey("errorMessage")) message = value["errorMessage"];
      });
      if (message.isNotEmpty) Toast.error(message);
    } else {
      if (error.response?.data['message'] != null) {
        Toast.error(error.response?.data['message']);
      }
    }
  }

  @override
  int getCode() {
    return 404;
  }

}