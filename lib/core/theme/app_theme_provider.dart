import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hesabo_chat_ai/core/theme/material_scheme_utils.dart';
import 'material_scheme.dart';

class AppThemeProvider {
  static TextTheme customTextTheme = TextTheme(
    displayLarge: TextStyle(
      // Giant
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w800,
      fontSize: 40,
      height: 48 / 40,
      letterSpacing: -0.05 * 40,
      // -5%
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      // Medium
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w500,
      fontSize: 40,
      height: 48 / 40,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      // Small
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w400,
      fontSize: 32,
      height: 40 / 32,
      color: Colors.white,
    ),
    headlineLarge: TextStyle(
      // Large
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w500,
      fontSize: 28,
      height: 36 / 28,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      // Medium
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w300,
      fontSize: 24,
      height: 32 / 24,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      // Small
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w800,
      fontSize: 20,
      height: 28 / 20,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      // Label Large
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w500,
      fontSize: 20,
      height: 28 / 20,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      // Label Medium
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w500,
      fontSize: 16,
      height: 24 / 16,
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      // Label Small
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 22 / 14,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      // Label Small Black
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w900,
      fontSize: 14,
      height: 20 / 14,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      // Micro
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 20 / 12,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      // Micro Black
      fontFamily: 'IRANYekanXFaNum',
      fontWeight: FontWeight.w900,
      fontSize: 12,
      height: 20 / 12,
      color: Colors.white,
    ),
  );

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff1a6585),
      surfaceTint: Color(0xff1a6585),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffc2e8ff),
      onPrimaryContainer: Color(0xff001e2c),
      secondary: Color(0xff4e616d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd1e5f3),
      onSecondaryContainer: Color(0xff091e28),
      tertiary: Color(0xff5f5a7d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffe5deff),
      onTertiaryContainer: Color(0xff1c1736),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfff6fafe),
      onBackground: Color(0xff171c1f),
      surface: Color(0xfff6fafe),
      onSurface: Color(0xff171c1f),
      surfaceVariant: Color(0xffdce3e9),
      onSurfaceVariant: Color(0xff40484d),
      outline: Color(0xff71787d),
      outlineVariant: Color(0xffc0c7cd),
      shadow: Color.fromARGB(38, 0, 0, 0),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inverseOnSurface: Color(0xffedf1f5),
      inversePrimary: Color(0xff8ecff2),
      primaryFixed: Color(0xffc2e8ff),
      onPrimaryFixed: Color(0xff001e2c),
      primaryFixedDim: Color(0xff8ecff2),
      onPrimaryFixedVariant: Color(0xff004d67),
      secondaryFixed: Color(0xffd1e5f3),
      onSecondaryFixed: Color(0xff091e28),
      secondaryFixedDim: Color(0xffb5c9d7),
      onSecondaryFixedVariant: Color(0xff364954),
      tertiaryFixed: Color(0xffe5deff),
      onTertiaryFixed: Color(0xff1c1736),
      tertiaryFixedDim: Color(0xffc9c1ea),
      onTertiaryFixedVariant: Color(0xff484364),
      surfaceDim: Color(0xffd6dade),
      surfaceBright: Color(0xfff6fafe),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f4f8),
      surfaceContainer: Color(0xffeaeef2),
      surfaceContainerHigh: Color(0xffe5e9ed),
      surfaceContainerHighest: Color(0xffdfe3e7),
    );
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xff8ecff2),
      surfaceTint: Color(0xff8ecff2),
      onPrimary: Color(0xff003548),
      primaryContainer: Color(0xff004d67),
      onPrimaryContainer: Color(0xffc2e8ff),
      secondary: Color(0xffb5c9d7),
      onSecondary: Color(0xff20333d),
      secondaryContainer: Color(0xff364954),
      onSecondaryContainer: Color(0xffd1e5f3),
      tertiary: Color(0xffc9c1ea),
      onTertiary: Color(0xff312c4c),
      tertiaryContainer: Color(0xff484364),
      onTertiaryContainer: Color(0xffe5deff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff0f1417),
      onBackground: Color(0xffdfe3e7),
      surface: Color(0xff0f1417),
      onSurface: Color(0xffdfe3e7),
      surfaceVariant: Color(0xff40484d),
      onSurfaceVariant: Color(0xffc0c7cd),
      outline: Color(0xff8a9297),
      outlineVariant: Color(0xff40484d),
      shadow: Color.fromARGB(120, 0, 0, 0),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe3e7),
      inverseOnSurface: Color(0xff2c3134),
      inversePrimary: Color(0xff1a6585),
      primaryFixed: Color(0xffc2e8ff),
      onPrimaryFixed: Color(0xff001e2c),
      primaryFixedDim: Color(0xff8ecff2),
      onPrimaryFixedVariant: Color(0xff004d67),
      secondaryFixed: Color(0xffd1e5f3),
      onSecondaryFixed: Color(0xff091e28),
      secondaryFixedDim: Color(0xffb5c9d7),
      onSecondaryFixedVariant: Color(0xff364954),
      tertiaryFixed: Color(0xffe5deff),
      onTertiaryFixed: Color(0xff1c1736),
      tertiaryFixedDim: Color(0xffc9c1ea),
      onTertiaryFixedVariant: Color(0xff484364),
      surfaceDim: Color(0xff0f1417),
      surfaceBright: Color(0xff353a3d),
      surfaceContainerLowest: Color(0xff0a0f12),
      surfaceContainerLow: Color(0xff171c1f),
      surfaceContainer: Color(0xff1b2023),
      surfaceContainerHigh: Color(0xff262b2e),
      surfaceContainerHighest: Color(0xff313539),
    );
  }

  static final light = theme(
    colorScheme: lightScheme().toColorScheme(),
    locale: const Locale('en'), // زبان پیش‌فرض
    selectedFont: 'IRANYekanXFanum-Medium', // فونت پیش‌فرض برای حالت تاریک
  );

  static final dark = theme(
    colorScheme: darkScheme().toColorScheme(),
    locale: const Locale('en'), // زبان پیش‌فرض
    selectedFont: 'IRANYekanXFanum-Medium', // فونت پیش‌فرض برای حالت تاریک
  );

  static AppTheme theme({
    required ColorScheme colorScheme,
    required Locale locale,
    required String selectedFont, // اضافه کردن فونت انتخابی
  }) {
    return AppTheme(
      data: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'IRANYekanXFaNum',
        textTheme: customTextTheme,
        brightness: colorScheme.brightness,
        scaffoldBackgroundColor: colorScheme.background,
        colorScheme: colorScheme,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorScheme.primary.withOpacity(0.4),
          selectionColor: colorScheme.secondaryContainer,
          selectionHandleColor: colorScheme.secondary,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          extendedTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: selectedFont, // اضافه کردن فونت
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 4,
          iconTheme: const IconThemeData(size: 22),
          backgroundColor: colorScheme.surface,
          surfaceTintColor: colorScheme.surface,
          shadowColor: Colors.black38,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            fontFamily: selectedFont, // اضافه کردن فونت
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: colorScheme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
            statusBarBrightness: colorScheme.brightness,
          ),
        ),
        // textTheme: TextTheme(
        //   labelSmall: TextStyle(
        //     color: colorScheme.onSurfaceVariant,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   labelMedium: TextStyle(
        //     color: colorScheme.onSurfaceVariant,
        //     fontFamily: selectedFont,
        //   ),
        //   labelLarge: TextStyle(
        //     color: colorScheme.onSurfaceVariant,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   bodySmall: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   bodyMedium: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   bodyLarge: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   titleSmall: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontWeight: FontWeight.bold,
        //     fontFamily: selectedFont,
        //   ),
        //   titleMedium: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontWeight: FontWeight.bold,
        //     fontFamily: selectedFont,
        //   ),
        //   titleLarge: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontWeight: FontWeight.bold,
        //     fontFamily: selectedFont,
        //   ),
        //   headlineSmall: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   headlineMedium: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   headlineLarge: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   displaySmall: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   displayMedium: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   displayLarge: TextStyle(
        //     color: colorScheme.onSurface,
        //     fontFamily: selectedFont,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
    );
  }
}

class AppTheme {
  AppTheme({required this.data});

  final ThemeData data;
}
