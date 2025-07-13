import 'package:flutter/material.dart';

import '../routing/cupertino_page_transition_builder.dart';
import '../routing/custom_transition.dart';

class Themes {
  static final light = ThemeData(
    // fontFamily: Assets.fontFamily,
    scaffoldBackgroundColor: Color(Colors.white.value),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: MainTransitionBuilder(),
        TargetPlatform.iOS:
            const CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
      },
    ),
  );
  // ..addCustom(ThemeColors());
  static final dark = ThemeData.dark();
  // ..addCustom(ThemeColors());
}
