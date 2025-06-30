import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension NullableStringEx on String? {
  bool isNullOrEmpty() {
    if (this == null || (this?.isEmpty ?? true)) {
      return true;
    }
    return false;
  }
}

extension IntegerExtensions on int {
  Color colorFromId() {
    int lastDigit = this % 10;
    List<Color> colors = [
      const Color(0xFFA5A6F6),
      const Color(0xFFFFAEAE),
      const Color(0xFF4DB1AE),
      const Color(0xFF6F5EAE),
      const Color(0xFF8FAEAE),
      const Color(0xFFAE6741),
      const Color(0xFFAE517B),
      const Color(0xFFA7AEA2),
      const Color(0xFF8C7F38),
      const Color(0xFF2E461A),
    ];

    return colors[lastDigit];
  }
}

extension StringExtensions on String {
  Color colorFromId() {
    int lastDigit = int.parse(substring(length - 1));
    List<Color> colors = [
      const Color(0xFFA5A6F6),
      const Color(0xFFFFAEAE),
      const Color(0xFF4DB1AE),
      const Color(0xFF6F5EAE),
      const Color(0xFF8FAEAE),
      const Color(0xFFAE6741),
      const Color(0xFFAE517B),
      const Color(0xFFA7AEA2),
      const Color(0xFF8C7F38),
      const Color(0xFF2E461A),
    ];

    return colors[lastDigit];
  }
}

extension NumExtension on num {
  EdgeInsets get top {
    return EdgeInsets.only(top: toDouble());
  }

  EdgeInsets get bottom {
    return EdgeInsets.only(bottom: toDouble());
  }

  EdgeInsets get left {
    return EdgeInsets.only(left: toDouble());
  }

  EdgeInsets get right {
    return EdgeInsets.only(right: toDouble());
  }

  EdgeInsets get horizontal {
    return EdgeInsets.symmetric(horizontal: toDouble());
  }

  EdgeInsets get vertical {
    return EdgeInsets.symmetric(vertical: toDouble());
  }
}

extension BuildContextHelper on BuildContext {
  double get screenWidth {
    return MediaQuery.sizeOf(this).width;
  }

  double get screenHeight {
    return MediaQuery.sizeOf(this).height;
  }

  double heightPercentage(double percentage) {
    return MediaQuery.sizeOf(this).height * (percentage / 100);
  }

  double widthPercentage(double percentage) {
    return MediaQuery.sizeOf(this).width * (percentage / 100);
  }
}

extension ListEx<T> on Iterable<T> {
  T? firstOrNull() {
    if (isEmpty) {
      return null;
    } else {
      return first;
    }
  }

  T? randomItem() {
    if (isEmpty) {
      return null;
    } else {
      return elementAt(Random().nextInt(length));
    }
  }

  T? lastOrNull() {
    if (isEmpty) {
      return null;
    } else {
      return last;
    }
  }

  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere((element) => test(element));
    } catch (e) {
      return null;
    }
  }

  T? maxBy(int Function(T element) selector) {
    int? maxValue;
    T? maxElement;
    forEach((element) {
      if (maxValue == null || selector(element) > maxValue!) {
        maxValue = selector(element);
        maxElement = element;
      }
    });

    return maxElement;
  }
}


extension DateTimeHourFormatting on DateTime {
  /// Formats the DateTime to an hour string in 24-hour format (00-23).
  /// Example: "14"
  String toHour24() {
    return DateFormat('HH').format(this);
  }

  /// Formats the DateTime to an hour string in 24-hour format, unpadded (0-23).
  /// Example: "8" or "14"
  String toHour24Unpadded() {
    return DateFormat('H').format(this);
  }

  /// Formats the DateTime to an hour string in 12-hour format (01-12).
  /// Example: "02" (for 2 PM)
  String toHour12() {
    return DateFormat('hh').format(this);
  }

  /// Formats the DateTime to an hour string in 12-hour format, unpadded (1-12).
  /// Example: "2" (for 2 PM) or "10"
  String toHour12Unpadded() {
    return DateFormat('h').format(this);
  }

  /// Formats the DateTime to an hour string in 12-hour format with AM/PM.
  /// Example: "2 PM"
  String toHour12AmPm({String? locale}) {
    return DateFormat('h a', locale).format(this);
  }

  /// Formats the DateTime to an hour and minute string in 24-hour format.
  /// Example: "14:30"
  String toHourMinute24() {
    return DateFormat('HH:mm').format(this);
  }

  /// Formats the DateTime to an hour and minute string in 12-hour format with AM/PM.
  /// Example: "2:30 PM"
  String toHourMinute12AmPm({String? locale}) {
    return DateFormat('h:mm a', locale).format(this);
  }
}

extension StringEx on String {
  String midEllipsis({int head = 8, int tail = 8}) {
    if (length > head + tail) {
      return '${substring(0, head)}...${substring(length - tail, length)}';
    }
    return this;
  }

  String ellipsis({int head = 20}) {
    if (length > head) {
      return substring(0, head);
    }
    return this;
  }

  String toHex() {
    return '0x$this';
  }

  String toHexIfNeeded() {
    if (startsWith('0x')) return this;
    return '0x$this';
  }

  bool isContain(String query) {
    return toLowerCase().contains(query.toLowerCase());
  }

  String toDatetime() {
    return DateFormat('MMMM dd yyyy – hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(this)));
  }

  String hourAmFromDate() {
    return DateFormat('hh:mm a').format(DateTime.parse(this).toLocal());
  }

  String get firstLetterUpperCase {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String get firstOrEmpty {
    if (length >= 1) {
      return this[0];
    } else {
      return '';
    }
  }

  String concat(String? str) {
    return this + (str ?? "");
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?!.*[*(),.?:{}|<>]).{8,}$')
        .hasMatch(this);
  }
}

extension UsernameValidator on String {
  bool isValidUsername() {
    return RegExp(
        r'^(?!.*[!@#$%^&*(),.?:{}|<>]).{3,}$')
        .hasMatch(this);
  }
}

extension CodeValidator on String {
  bool isCodeValidator() {
    return RegExp(
        r'^.{6}$')
        .hasMatch(this);
  }
}

extension GlobalPaintBounds on BuildContext {
  Rect? get globalPaintBounds {
    final renderObject = findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}
