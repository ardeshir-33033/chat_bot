import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/pages/auth_selection_page.dart';
import 'package:hesabo_chat_ai/core/theme/material_scheme_utils.dart';
import 'package:hesabo_chat_ai/core/theme/theme_service.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:bot_toast/bot_toast.dart';
import 'core/theme/app_theme_provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupHive();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
  setup();
}

setupHive() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final hivePath = '${appDocumentDir.path}/hive_data';

  // Ensure the directory exists (optional, Hive usually handles this)
  final directory = Directory(hivePath);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  Hive.init(hivePath);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final botToastBuilder = BotToastInit();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      builder: (context, child) {
        child = botToastBuilder(context, child);
        return ResponsiveBreakpoints.builder(
          child: child,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
      },
      theme: AppThemeProvider.theme(
        colorScheme: AppThemeProvider.lightScheme().toColorScheme(),
        locale: Locale('fa', "IR"),
        selectedFont: 'IRANYekanXFanum-Light',
      ).data,
      // theme: Themes.light,
      // darkTheme: Themes.dark,
      // home: ChatBotPage(),
      home: const AuthSelectionPage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
