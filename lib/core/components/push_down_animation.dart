import 'package:flutter/material.dart';

class PushDownAnimation extends StatefulWidget {
  const PushDownAnimation({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 130),
    this.enabled = true,
  });

  final Widget child;
  final Duration duration;
  final bool enabled;

  @override
  _PushDownAnimationState createState() => _PushDownAnimationState();
}

class _PushDownAnimationState extends State<PushDownAnimation>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      upperBound: 0.05,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(Duration(milliseconds: widget.duration.inMilliseconds + 20),
        () {
      _controller.reverse();
    });
  }

  void _onTapCancel() {
    Future.delayed(Duration(milliseconds: widget.duration.inMilliseconds + 20),
        () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.enabled ? _onTapDown : null,
      onTapUp: widget.enabled ? _onTapUp : null,
      onTapCancel: widget.enabled ? _onTapCancel : null,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
