import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get appVersion => dotenv.env['APP_VERSION']!;
  static String get apiBaseUrl => dotenv.env['API_BASE_URL']!;
  static String get clientId => dotenv.env['CLIENT_ID']!;
  static String get clientSecret => dotenv.env['CLIENT_SECRET']!;
  static bool get debug => true;
  static bool get canChangeApiBaseUrl =>
      dotenv.env['CAN_CHANGE_API_BASE_URL']! == 'true';
  static String get downloadAppLink => dotenv.env['DOWNLOAD_APP_LINK']!;
}
