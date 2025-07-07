import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hesabo_chat_ai/features/core/components/push_down_animation.dart';
import 'package:hesabo_chat_ai/features/core/components/switcher.dart';
import 'package:hesabo_chat_ai/features/core/utils/color_helper.dart';
import 'loading_widget.dart';

enum ButtonType { primary, secondary, tertiary }
enum ButtonVariant { elevated, outlined, text }

class ChatBotButton extends StatefulWidget {
  const ChatBotButton({
    required this.title,
    this.onPressed,
    this.child,
    this.fitted = false,
    bool widthFromHeight = false,
    double? width,
    this.titleStyle,
    this.enabled = true,
    this.loading,
    this.height = 48,
    this.color,
    this.maxWidth,
    this.minWidth,
    this.borderSide = BorderSide.none,
    this.type = ButtonType.primary,
    this.variant = ButtonVariant.elevated,
    super.key,
    this.icon,
    this.iconSize = 22,
    this.foregroundColor,
    this.margin,
    this.elevation,
    this.buttonAlignment = Alignment.center,
    this.buttonAlignmentDirectional,
    this.label,
  }) : width = widthFromHeight ? height : (width ?? double.infinity);

  final Widget? child;
  final String title;
  final String? label;
  final bool fitted;
  final TextStyle? titleStyle;
  final Future<void> Function()? onPressed;
  final bool enabled;
  final bool? loading;
  final double width;
  final double height;
  final Color? color;
  final double? maxWidth;
  final double? minWidth;
  final BorderSide borderSide;
  final ButtonType type;
  final ButtonVariant variant;
  final IconData? icon;
  final EdgeInsets? margin;
  final double iconSize;
  final Color? foregroundColor;
  final double? elevation;
  final Alignment? buttonAlignment;
  final AlignmentDirectional? buttonAlignmentDirectional;

  @override
  State<ChatBotButton> createState() => SirButtonState();
}

class SirButtonState extends State<ChatBotButton> {
  bool loading = false;

  bool get finalLoading => widget.loading ?? loading;

  @override
  Widget build(BuildContext context) => PushDownAnimation(
    enabled: widget.enabled,
    child: Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth ?? double.infinity,
        minWidth: widget.minWidth ?? 0,
      ),
      child: _buildButton(
        context,
        _buildButtonChild(context),
      ),
    ),
  );

  Widget _buildButton(BuildContext context, Widget child) {
    final style = _buildButtonStyle(context);

    switch (widget.variant) {
      case ButtonVariant.elevated:
        return ElevatedButton(
          onPressed: _handlePress,
          style: style,
          child: child,
        );
      case ButtonVariant.outlined:
        return OutlinedButton(
          onPressed: _handlePress,
          style: style,
          child: child,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: _handlePress,
          style: style,
          child: child,
        );
    }
  }

  ButtonStyle _buildButtonStyle(BuildContext context) {
    final backgroundColor = widget.color ?? _getTypeColor(context);
    final foregroundColor = widget.foregroundColor ?? _getOnTypeColor(context);

    return ButtonStyle(
      elevation: WidgetStateProperty.all(widget.elevation ?? 0),
      backgroundColor: widget.variant == ButtonVariant.text
          ? null
          : WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : backgroundColor,
      ),
      foregroundColor: WidgetStateProperty.all(foregroundColor),
      shadowColor: WidgetStateProperty.all(
        widget.enabled ? Theme.of(context).colorScheme.shadow : Colors.transparent,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: widget.borderSide,
        ),
      ),
      overlayColor: WidgetStatePropertyAll(
        _getTypeColor(context).darken(.05),
      ),
      padding: WidgetStateProperty.all(const EdgeInsets.all(4)),
    );
  }

  Widget _buildButtonChild(BuildContext context) {
    final foregroundColor = widget.foregroundColor ?? _getOnTypeColor(context);

    return Switcher(
      child: finalLoading
          ? Center(
        key: const Key('loading'),
        child: LoadingWidget(
          color: foregroundColor,
          size: widget.height / 3,
        ),
      )
          : (widget.child ?? _defaultContent(context, foregroundColor)),
    );
  }

  Widget _defaultContent(BuildContext context, Color foregroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: widget.buttonAlignmentDirectional ?? widget.buttonAlignment,
      key: Key('normal${widget.title}'),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: <Widget>[
          if (widget.icon != null)
            Icon(
              widget.icon,
              size: widget.iconSize,
              color: foregroundColor,
            ),
          if (widget.title.isNotEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.fitted)
                  FittedBox(
                    child: Text(
                      widget.title,
                      style: widget.titleStyle ?? Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: foregroundColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  )
                else
                  Text(
                    widget.title,
                    style: widget.titleStyle ?? Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: widget.titleStyle ?? Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: foregroundColor.withOpacity(.5),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  void _handlePress() async {
    if (!widget.enabled || finalLoading) return;

    setState(() => loading = true);
    FocusScope.of(context).unfocus();

    final result = widget.onPressed?.call();
    if (result is Future) await result;

    if (mounted) setState(() => loading = false);
  }

  Color _getTypeColor(BuildContext context) {
    if (widget.color != null) return widget.color!;

    if (!widget.enabled) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }

    switch (widget.type) {
      case ButtonType.primary:
        return Theme.of(context).colorScheme.primary;
      case ButtonType.secondary:
        return Theme.of(context).colorScheme.surface;
      case ButtonType.tertiary:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }

  Color _getOnTypeColor(BuildContext context) {
    if (!widget.enabled) {
      return Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3);
    }

    switch (widget.type) {
      case ButtonType.primary:
        return Theme.of(context).colorScheme.onPrimary;
      case ButtonType.secondary:
        return Theme.of(context).colorScheme.onSurface;
      case ButtonType.tertiary:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
