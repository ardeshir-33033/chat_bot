import 'package:get/get.dart';
import 'package:hesabo_chat_ai/core/data/auth_data_controller.dart';
import 'package:hesabo_chat_ai/core/data/data_state.dart';
import 'package:hesabo_chat_ai/core/storage/hive/hive_constants.dart';
import 'package:hesabo_chat_ai/core/storage/hive/hive_local_storage.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/auth/data/models/auth_tokens_model.dart';
import 'package:hesabo_chat_ai/features/auth/domain/usecase/login_usecase.dart';
import 'package:hesabo_chat_ai/features/auth/domain/usecase/register_usecase.dart';
import 'package:hesabo_chat_ai/features/auth/domain/usecase/verify_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyUseCase _verifyUseCase;
  final HiveLocalStorage _localStorage;

  AuthController(
    this._loginUseCase,
    this._registerUseCase,
    this._verifyUseCase,
    this._localStorage,
  );

  String? tempSmsCode;
  final tokenKey = 'accessToken';
  final refreshKey = 'refreshToken';
  final userIdKey = 'userId';

  Future<bool> initAuth() async {
    String? accessToken = await getAccessToken();
    // getRefreshToken();
    String? userId = await getUserId();
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }
    locator<AuthDataController>().authTokens = AuthTokens(
      access: accessToken ?? '',
      refresh: '',
      personId: int.tryParse(userId ?? '') ?? 0,
    );
    return true;
  }

  Future<bool> login(String phoneNumber, String password) async {
    try {
      final result = await _loginUseCase(
        params: LoginParams(phoneNumber: phoneNumber, password: password),
      );
      if (result is DataSuccess<AuthTokens>) {
        locator<AuthDataController>().authTokens = result.data;
        saveAccessToken(result.data.access);
        saveRefreshToken(result.data.refresh);
        saveUserId(result.data.personId.toString());

        final s = await getUserId();
        print(s);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<DataState> verify(String phoneNumber, String code) async {
    try {
      final result = await _verifyUseCase(
        params: VerifyParams(phoneNumber: phoneNumber, code: code),
      );
      if (result is DataSuccess<AuthTokens>) {
        locator<AuthDataController>().authTokens = result.data;
        saveAccessToken(result.data.access);
        saveRefreshToken(result.data.refresh);
        saveUserId(result.data.personId.toString());

        return result;
      } else {
        return result;
      }
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<DataState> register(String phoneNumber, String password) async {
    final result = await _registerUseCase(
      params: RegisterParams(phoneNumber: phoneNumber, password: password),
    );
    if (result is DataSuccess<String>) {
      tempSmsCode = result.data;
      return result;
    } else {
      return result;
    }
  }

  Future logout() async {
    await saveAccessToken('');
    await saveRefreshToken('');
    await saveUserId('');
    locator<AuthDataController>().authTokens = AuthTokens(
      access: '',
      refresh: '',
      personId: 0,
    );
  }

  Future<void> saveAccessToken(String token) {
    return _localStorage.saveData<String>(
      boxKey: HiveConstants.accessToken,
      objectKey: tokenKey,
      data: token,
    );
  }

  Future<void> saveRefreshToken(String token) {
    return _localStorage.saveData<String>(
      boxKey: HiveConstants.refreshToken,
      objectKey: refreshKey,
      data: token,
    );
  }

  Future<void> saveUserId(String userId) {
    return _localStorage.saveData<String>(
      boxKey: HiveConstants.userIdBox,
      objectKey: userIdKey,
      data: userId,
    );
  }

  Future<String?> getAccessToken() {
    return _localStorage.getData<String?>(
      boxKey: HiveConstants.accessToken,
      objectKey: tokenKey,
    );
  }

  Future<String?> getRefreshToken() {
    return _localStorage.getData<String?>(
      boxKey: HiveConstants.refreshToken,
      objectKey: refreshKey,
    );
  }

  Future<String?> getUserId() {
    return _localStorage.getData<String?>(
      boxKey: HiveConstants.userIdBox,
      objectKey: userIdKey,
    );
  }
}
