import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget(
      {this.size = 24, this.strokeWidth = 3.5, super.key, this.color});
  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color ?? Theme.of(context).colorScheme.primary,
          strokeWidth: strokeWidth,
        ),
      );
}
