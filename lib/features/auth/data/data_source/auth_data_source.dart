import 'package:dio/dio.dart';
import 'package:hesabo_chat_ai/features/core/api_routing/auth_routing.dart';
import 'package:hesabo_chat_ai/features/core/data/http_response.dart';

abstract class AuthDataSource {
  Future<HttpResponse<void>> getPasswordStatus({required String phoneNumber});

  Future<HttpResponse<void>> postLogin({
    required String phoneNumber,
    required String password,
  });
}

class AuthDataSourceImpl extends AuthDataSource {
  @override
  Future<HttpResponse<void>> getPasswordStatus({
    required String phoneNumber,
  }) async {
    var headers = {
      'role': 'employee',
      'Cookie':
          'FGTServer=735F07D05DD730BD20B9CB7403580EDF41EFE943506E7DBBA1F1FF7C0C6CBB1D2F9C7F90838D86',
    };

    var dio = Dio();

    var response = await dio.request(
      '${AuthRouting.passwordStatusRoute}?phoneNumber=$phoneNumber',
      options: Options(method: 'GET', headers: headers),
    );

    if (response.statusCode == 200) {
      final res = HttpResponse<void>(null, response);
      return res;
    } else {
      throw Exception(response.toString());
    }
  }

  @override
  Future<HttpResponse<void>> postLogin({
    required String phoneNumber,
    required String password,
  }) async {
    var headers = {
      // 'role': 'employee',
      'Cookie':
          'FGTServer=735F07D05DD730BD20B9CB7403580EDF41EFE943506E7DBBA1F1FF7C0C6CBB1D2F9C7F90838D86',
    };

    var dio = Dio();

    var response = await dio.request(
      AuthRouting.login,
      data: {'phoneNumber': phoneNumber, 'password': password},
      options: Options(method: 'POST', headers: headers),
    );

    if (response.statusCode == 200) {
      final res = HttpResponse<void>(null, response);
      return res;
    } else {
      throw Exception(response.toString());
    }
  }
}
