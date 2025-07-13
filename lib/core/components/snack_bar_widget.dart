import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

enum SnackType { failure, success, normal }

class SnackBarWidget {
  const SnackBarWidget._();

  static showSnackBar({
    required SnackType snackType,
    required String title,
    Widget? customWidget,
    Duration? duration,
  }) {
    BotToast.showCustomNotification(
      toastBuilder: (cancelFunc) =>
          _snackBarWidget(snackType, title, customWidget),
      duration: duration ?? const Duration(milliseconds: 2500),
      animationDuration: const Duration(milliseconds: 600),
      useSafeArea: true,
    );
  }

  static Widget _snackBarWidget(
      SnackType snackType, String title, Widget? customWidget) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        color: _snackTypeColor(snackType),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            if (customWidget != null) customWidget
          ],
        ),
      ),
    );
  }

  static Color _snackTypeColor(SnackType snackType) {
    switch (snackType) {
      case SnackType.success:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  static showSuccessSnackBar(BuildContext context, String title) {
    showSnackBar(
      snackType: SnackType.success,
      title: title,
    );
  }

  static showFailedSnackBar(BuildContext context, String? title) {
    showSnackBar(
      snackType: SnackType.failure,
      title: title ?? "",
    );
  }
}
