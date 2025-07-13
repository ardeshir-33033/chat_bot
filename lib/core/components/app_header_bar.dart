import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor; // For title and icon color
  final double? elevation;
  final VoidCallback? onLeadingPressed; // Optional: if leading is an IconButton
  final PreferredSizeWidget? bottom; // For TabBar or other widgets below AppBar
  final bool centerTitle;

  const MyAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onLeadingPressed,
    this.bottom,
    this.centerTitle = true, // Common default, can be overridden
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);

    Widget? effectiveLeading = leading;
    if (effectiveLeading == null &&
        onLeadingPressed != null &&
        Navigator.canPop(context)) {
      effectiveLeading = IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onLeadingPressed ?? () => Navigator.maybePop(context),
        color:
            foregroundColor ??
            appBarTheme.iconTheme?.color ??
            theme.colorScheme.onPrimary,
      );
    } else if (effectiveLeading == null && onLeadingPressed != null) {
      // If onLeadingPressed is provided but no specific leading, and can't pop (e.g. root screen with drawer)
      // You might want a menu icon by default, or leave it null based on your app's logic
      // For instance, to open a drawer:
      // effectiveLeading = IconButton(
      //   icon: const Icon(Icons.menu),
      //   tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      //   onPressed: onLeadingPressed, // This would typically be Scaffold.of(context).openDrawer()
      //   color: foregroundColor ?? appBarTheme.iconTheme?.color ?? theme.colorScheme.onPrimary,
      // );
    }

    return AppBar(
      title: Text(title),
      leading: effectiveLeading,
      actions: actions,
      backgroundColor:
          backgroundColor ??
          appBarTheme.backgroundColor ??
          theme.colorScheme.primary,
      foregroundColor:
          foregroundColor ??
          appBarTheme.foregroundColor ??
          theme.colorScheme.onPrimary,
      elevation: elevation ?? appBarTheme.elevation ?? 4.0,
      // Default elevation
      centerTitle: centerTitle,
      bottom: bottom,
      iconTheme:
          appBarTheme.iconTheme?.copyWith(color: foregroundColor) ??
          IconThemeData(color: foregroundColor ?? theme.colorScheme.onPrimary),
      actionsIconTheme:
          appBarTheme.actionsIconTheme?.copyWith(color: foregroundColor) ??
          IconThemeData(color: foregroundColor ?? theme.colorScheme.onPrimary),
      toolbarTextStyle:
          appBarTheme.toolbarTextStyle?.copyWith(color: foregroundColor) ??
          theme.textTheme.bodyMedium?.copyWith(
            color: foregroundColor ?? theme.colorScheme.onPrimary,
          ),
      titleTextStyle:
          appBarTheme.titleTextStyle?.copyWith(color: foregroundColor) ??
          theme.textTheme.titleLarge?.copyWith(
            color: foregroundColor ?? theme.colorScheme.onPrimary,
          ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
