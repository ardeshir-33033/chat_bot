import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/core/theme/material_scheme_utils.dart';
import 'package:hesabo_chat_ai/features/core/theme/theme_service.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:bot_toast/bot_toast.dart';

import 'features/chat_bot/presentation/pages/chat_bot_page.dart';
import 'features/core/theme/app_theme_provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
  setup();
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
        selectedFont:
            'IRANYekanXFanum-Light', // اعمال فونت انتخابی برای تم تاریک
      ).data,
      // theme: Themes.light,
      // darkTheme: Themes.dark,
      home: const ChatBotPage(),
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}