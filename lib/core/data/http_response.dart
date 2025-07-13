import 'package:dio/dio.dart';

class HttpResponse<T> {
  final T data;
  final Response response;

  HttpResponse(this.data, this.response);
}
