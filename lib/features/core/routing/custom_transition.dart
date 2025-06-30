import 'dart:io';

import 'package:flutter/material.dart';

class MainTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
          .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutQuint,
              reverseCurve: Curves.easeInOutQuad)),
      child: SlideTransition(
        position:
            Tween<Offset>(end: const Offset(-0.3, 0.0), begin: Offset.zero)
                .animate(CurvedAnimation(
                    parent: secondaryAnimation,
                    curve: Curves.easeInOutQuint,
                    reverseCurve: Curves.easeInOutQuad)),
        child: child,
      ),
    );
  }
}

// class MainTransition extends CustomTransition {
//   @override
//   Widget buildTransition(
//       BuildContext context,
//       Curve? curve,
//       Alignment? alignment,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation,
//       Widget child) {
//     return Align(
//         alignment: alignment ?? Alignment.center,
//         child: SlideTransition(
//           position:
//               Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
//                   .animate(CurvedAnimation(
//                       parent: animation,
//                       curve: Curves.easeInOutQuint,
//                       reverseCurve: Curves.easeInOutQuad)),
//           child: SlideTransition(
//             position:
//                 Tween<Offset>(end: const Offset(-0.3, 0.0), begin: Offset.zero)
//                     .animate(CurvedAnimation(
//                         parent: secondaryAnimation,
//                         curve: Curves.easeInOutQuint,
//                         reverseCurve: Curves.easeInOutQuad)),
//             child: child,
//           ),
//         ));
//   }
// }

class CustomMaterialPageRoute extends MaterialPageRoute {
  @override
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  CustomMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

class MyWillPopScope extends StatelessWidget {
  const MyWillPopScope({
    required this.child,
    this.onWillPop,
    super.key,
  });

  final Widget child;
  final WillPopCallback? onWillPop;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? GestureDetector(
            onHorizontalDragEnd: Platform.isIOS
                ? (details) async {
                    if (details.primaryVelocity! > 0 &&
                        details.primaryVelocity!.abs() > 500) {
                      try {
                        onWillPop!.call();
                      } catch (e) {
                        // log('error: $e');
                      }
                    }
                  }
                : null,
            // onHorizontalDragUpdate: (details) {
            //   if (details.delta.dx > 0 && onWillPop != null) {
            //     onWillPop!.call();
            //   }
            // },
            child: WillPopScope(
              onWillPop: onWillPop,
              child: child,
            ),
          )
        : WillPopScope(
            onWillPop: onWillPop,
            child: child,
          );
  }
}
