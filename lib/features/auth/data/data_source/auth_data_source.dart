import 'package:dio/dio.dart';
import 'package:hesabo_chat_ai/core/api_routing/auth_routing.dart';
import 'package:hesabo_chat_ai/core/data/http_response.dart';
import 'package:hesabo_chat_ai/features/auth/data/models/auth_tokens_model.dart';

abstract class AuthDataSource {
  Future<HttpResponse<String>> register({
    required String phoneNumber,
    required String password,
  });

  Future<HttpResponse<AuthTokens>> login({
    required String phoneNumber,
    required String password,
  });

  Future<HttpResponse<AuthTokens>> verify({
    required String phoneNumber,
    required String code,
  });
}

class AuthDataSourceImpl extends AuthDataSource {
  @override
  Future<HttpResponse<String>> register({
    required String phoneNumber,
    required String password,
  }) async {
    var dio = Dio();

    var response = await dio.request(
      AuthRouting.register,
      data: {'password': password, 'phone_number': phoneNumber},
      options: Options(method: 'POST'),
    );

    if (response.statusCode == 200) {
      response.data = response.headers['X-Test-Code']!.first;
      final res = HttpResponse<String>(response.data, response);
      return res;
    } else {
      throw Exception(response.toString());
    }
  }

  @override
  Future<HttpResponse<AuthTokens>> login({
    required String phoneNumber,
    required String password,
  }) async {
    var dio = Dio();

    var response = await dio.request(
      AuthRouting.login,
      data: {'phone_number': phoneNumber, 'password': password},
      options: Options(method: 'POST'),
    );

    if (response.statusCode == 200) {
      final data = AuthTokens.fromJson(response.data);

      final res = HttpResponse<AuthTokens>(data, response);
      return res;
    } else {
      throw Exception(response.toString());
    }
  }

  @override
  Future<HttpResponse<AuthTokens>> verify({
    required String phoneNumber,
    required String code,
  }) async {
    var dio = Dio();

    var response = await dio.request(
      AuthRouting.verify,
      data: {'phone_number': phoneNumber, 'code': code},
      options: Options(method: 'POST'),
    );

    if (response.statusCode == 200) {
      final data = AuthTokens.fromJson(response.data);

      final res = HttpResponse<AuthTokens>(data, response);
      return res;
    } else {
      throw Exception(response.toString());
    }
  }
}
