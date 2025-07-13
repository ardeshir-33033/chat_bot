import 'package:flutter/material.dart';
import 'glass_loading_component.dart'; // Adjust import path

class LoadingOverlayManager {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context, {String message = 'Loading...'}) {
    // If an overlay is already showing, do nothing or update it
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => GlassLoadingOverlay(
        message: message,
        child: Container(), // The main content behind the overlay (not relevant for full screen)
      ),
    );

    // Insert the overlay into the overlay stack
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove(); // Remove the overlay from the stack
      _overlayEntry = null; // Clear the reference
    }
  }
}