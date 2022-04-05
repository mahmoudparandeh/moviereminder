import '../api_builder.dart';

abstract class Middleware{
  void invoke(ApiBuilder apiBuilder);
}