import 'package:dio/dio.dart';
import 'package:moviereminder/network/methods/method.dart';
import 'package:moviereminder/network/middleware/middleware.dart';
import 'dio.factory.dart';
import 'error/default_error.dart';
import 'error/error401.dart';
import 'error/error403.dart';
import 'error/error404.dart';
import 'error/error422.dart';
import 'error/error500.dart';

class ApiBuilder{
  Options options = Options();
  String route = '';
  String baseUrl = 'https://moviereminder.licharstudio.com/api/v1/client';
  late Dio httpClient;
  late Method method;
  Map<String, dynamic> query = {};
  Map<String, dynamic> body = {};
  FormData formData = FormData();
  Map<String, dynamic> header = {};
  List<Middleware> middlewares = [];
  late ResponseType responseType;

  ApiBuilder() {
    httpClient = DioClient().dio;
    responseType = ResponseType.json;
  }

  bool isValid(String value) {
  return value.trim() != '';
  }

  ApiBuilder addQuery(String key, dynamic value) {
    if(isValid(value.toString())) {
      query[key] = value;
    }
    return this;
  }

  ApiBuilder removeQuery(String key) {
    query.remove(key);
    return this;
  }

  ApiBuilder removeQueries() {
    query = {};
    return this;
  }

  ApiBuilder addBody(String key, dynamic value) {
    if(isValid(value)) {
      body[key] = value;
    }
    return this;
  }

  ApiBuilder addBodyArray(String key, dynamic value) {
    if(isValid(value)) {
      List<dynamic> data = [];
      data.add(value);
      body[key] = data;
    }
    return this;
  }

  ApiBuilder addBodyObject(String key, dynamic value) {
    body[key] = value;
    return this;
  }


  ApiBuilder removeBody(String key) {
    body.remove(key);
    return this;
  }

  ApiBuilder removeBodies() {
    body = {};
    return this;
  }

  ApiBuilder addHeader(String key, String value) {
    if(isValid(value)) {
      header[key] = value;
    }
    return this;
  }

  ApiBuilder removeHeader(String key) {
    header.remove(key);
    return this;
  }

  ApiBuilder addMiddleware(Middleware middleware) {
    middlewares.add(middleware);
    return this;
  }

  ApiBuilder addResponseType(ResponseType responseType) {
    this.responseType = responseType;
    return this;
  }

  String buildQueries() {
    String queryString = '';
    if(query != {}) {
      queryString += '?';
    }
    query.forEach((key, value) {
      queryString += key + '=' + value.toString() + '&';
    });
    queryString = queryString.substring(0, queryString.length - 1);
    return queryString;
  }

  void runMiddleWares() {
    for (var element in middlewares) {
      element.invoke(this);
    }
  }

  ApiBuilder setMethod(Method method) {
    this.method = method;
    return this;
  }

  ApiBuilder setRoute(String route) {
    this.route = route;
    return this;
  }

  Future<Response?> call() async{
    runMiddleWares();
    options.headers = header;
    options.responseType = responseType;
    try {
      return await method.action(httpClient: httpClient,
          route: baseUrl + route + buildQueries(),
          options: options,
          data: formData.fields.isEmpty  ? body : formData);
    } on DioError catch (error) {
      if(error.response?.statusCode != null) {
        switch(error.response?.statusCode) {
          case 401 :
            {
              Error401().action(error);
              break;
            }
          case 403 :
            {
              Error403().action(error);
              break;
            }
          case 404 :
            {
              Error404().action(error);
              break;
            }
          case 422 :
            {
              Error422().action(error);
              break;
            }
          case 500 :
            {
              Error500().action(error);
              break;
            }
          default: {
            ErrorDefault().action(error);
            break;
          }
        }
        return null;
      }
    }
    return null;
  }


}