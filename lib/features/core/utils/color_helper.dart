import 'package:flutter/material.dart';

extension ColorHelper on Color {
  Color toRGB() {
    return Color.fromRGBO(red, green, blue, 0);
  }

  String toHexString() =>
      (value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();

  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0 to 1');

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0 to 1');

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
