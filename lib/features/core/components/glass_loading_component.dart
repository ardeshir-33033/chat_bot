import 'dart:ui'; // For ImageFilter.blur
import 'package:flutter/material.dart';

class GlassLoadingOverlay extends StatelessWidget {
  final Widget child; // The content to display inside the glass
  final String message; // The message to show (e.g., "Loading...")
  final Color barrierColor; // Color of the semi-transparent overlay
  final double blurAmount; // How much to blur the background

  const GlassLoadingOverlay({
    Key? key,
    required this.child,
    this.message = 'Loading...',
    this.barrierColor = Colors.black45, // Semi-transparent black
    this.blurAmount = 5.0, // Default blur
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Important for the blur to show through
      child: Stack(
        children: [
          // Background filter for glassmorphism effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
            child: Container(
              color: barrierColor, // This color applies to the blurred area
            ),
          ),
          Center(
            child: Container(
              // Optional: Add a subtle background to the central content
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1), // Very subtle transparent white
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
              ),
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.bubble_chart_sharp, // Or any other icon you prefer
                    size: 60.0,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black26,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    strokeWidth: 3.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}