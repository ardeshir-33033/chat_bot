import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> initEnvironment() async {
    // if (kIsProduction) {
    await dotenv.load(fileName: "production.env");
    // } else if (kIsStage || kIsTest) {
    //   await dotenv.load(fileName: "stage.env");
    // } else {
    //   await dotenv.load(fileName: "develop.env");
    // }
  }

  // static String get environment {
  //   if (kIsDevelop) {
  //     return "Develop";
  //   } else if (kIsStage) {
  //     return "Staging";
  //   }
  //   return "";
  // }

  static String getBaseUrl() {
    return "https://api.hesabodev.ir/";
    // return dotenv.get("CAPTCHA_WEB_PATH");
  }

  static String getAuthBaseUrl() {
    return "https://api.hesabodev.ir/";
    // return dotenv.get("CAPTCHA_WEB_PATH");
  }
}
