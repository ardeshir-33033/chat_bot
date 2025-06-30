import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

typedef ExecuteCallback = void Function();
typedef ExecuteFutureCallback = Future<void> Function();

void postFrameCallback(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) => callback.call());
}

// String? getThumbnailUrl(String? originalUrl) {
//   return originalUrl?.replaceFirst(
//       RegExp(r'_\d+\.\w+$'), '_1.$thumbnailFileExtension');
// }

String getFileExtension(String? fileName) {
  if (fileName == null) return '';
  return RegExp(r'\.(\w+)$').firstMatch(fileName)?.group(1) ?? '';
}

void dismissKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Future<void> doTry(
    {ExecuteCallback? runSync,
    ExecuteFutureCallback? runAsync,
    ExecuteCallback? onError}) async {
  try {
    runSync?.call();
    await runAsync?.call();
  } catch (e) {
    // SnackMsg.showError(Get.context!, 'Error: $e');
    onError?.call();
  }
}

String getTURNCredentials(String name, String secret, String dateTime) {
  print("Turn Credentials");

  print("unixTimeStamp: $dateTime");
  String username = '$dateTime:$name';
  String password;

  // Create HMAC object with the secret key and SHA1 hashing algorithm
  var hmac = Hmac(sha1, utf8.encode(secret));

  // Generate HMAC
  List<int> hmacBytes = hmac.convert(utf8.encode(username)).bytes;

  // Encode HMAC to Base64
  password = base64.encode(hmacBytes);

  print("password: $password");

  return password;
}

String getRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (index) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

int getRandomNumber({int? min, int? max}) {
  min = min ?? 0;
  max = max ?? 1000;
  final random = Random();
  return min + random.nextInt(max - min);
}

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(
    ClipboardData(
      text: text,
    ),
  );
  // Fluttertoast.showToast(
  //   msg: "Copied",
  //   toastLength: Toast.LENGTH_SHORT,
  //   gravity: ToastGravity.BOTTOM,
  //   backgroundColor: Colors.grey[600],
  //   textColor: Colors.white,
  //   fontSize: 16.0,
  // );
}

Future<void> launchExternalUrl(
  String url, {
  Function(dynamic)? onError,
}) async {
  try {
    // await launchUrl(
    //   Uri.parse(url),
    //   mode: LaunchMode.platformDefault,
    //   webViewConfiguration: const WebViewConfiguration(
    //     enableJavaScript: true,
    //   ),
    // );
  } catch (e) {
    onError?.call(e);
  }
}

Future<bool> isImageCached(String key) async {
  return await DefaultCacheManager().getFileFromCache(key) != null;
}

String getImageCacheKey(String key, {bool thumbnail = false}) {
  return 'image_$key${thumbnail ? '_thumbnail' : ''}';
}

// Future<File?> getCachedFile(String key, FileType fileType) async {
//   if (fileType == FileType.file || fileType == FileType.audio) {
//     final directory = await getTemporaryDirectory();
//     final file = File("${directory.path}/$key");
//     if (file.existsSync()) {
//       return file;
//     }
//     return null;
//   }
//   final fileInfo = await getCachedImage(key);
//   return fileInfo?.file;
// }

Future<FileInfo?> getCachedImage(String key) {
  return DefaultCacheManager().getFileFromCache(key);
}

String generateUUID() {
  var uuid = const Uuid();
  return uuid.v4();
}

Future cacheFile(String key, Uint8List fileBytes) async {
  await DefaultCacheManager().putFile(key, fileBytes);
}

Future<void> saveImageInGallery(
  String tag,
  BuildContext context, {
  Uint8List? imageList,
  String? url,
}) async {
  var response;
  if (url != null) {
    response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
  }
  // final result = await ImageGallerySaver.saveImage(
  //     url != null ? Uint8List.fromList(response.data) : imageList!,
  //     quality: 60,
  //     name: tag);
  // if (result["isSuccess"] ?? false) {
  //   Fluttertoast.showToast(
  //     msg: "Image Saved To Gallery",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.grey[600],
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // }
}

int generateUniqueId() {
  Random random = Random();
  int uniqueId = random.nextInt(300);
  return uniqueId;
}
