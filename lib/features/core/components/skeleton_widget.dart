import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget.rectangular({
    required this.width,
    required this.height,
    super.key,
    this.highLightColor,
    this.baseColor,
  }) : shape = BoxShape.rectangle;

  const SkeletonWidget.circular({
    required this.width,
    required this.height,
    super.key,
    this.highLightColor,
    this.baseColor,
  }) : shape = BoxShape.circle;
  final double height;
  final double width;
  final BoxShape shape;
  final Color? highLightColor;
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : const BorderRadius.all(Radius.circular(10)),
        color: baseColor ?? const Color(0xffF5F5F5),
      ),
      child: SkeletonAnimation(
        shimmerColor: highLightColor ?? const Color(0xffecebeb),
        shimmerDuration: 1500,
        gradientColor: baseColor ?? const Color(0xffF5F5F5),
        borderRadius: shape == BoxShape.circle
            ? const BorderRadius.all(Radius.circular(100))
            : const BorderRadius.all(Radius.circular(10)),
        child: const SizedBox(),
      ),
    );
  }
}
