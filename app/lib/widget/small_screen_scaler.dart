import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Renders the app on a virtual canvas that is scaled down for very small viewports.
///
/// Hardware panels can be far smaller than anything the layouts are designed
/// for (e.g. a 308x240 landscape screen). On such viewports, the whole app is
/// laid out on a virtual canvas whose shorter side is [minDesignSide] logical
/// pixels (same aspect ratio) and then scaled down to fit the real viewport.
/// The [MediaQuery] is replaced accordingly, so all layout code sees a regular
/// phone-sized screen and no per-screen small-screen handling is needed.
class SmallScreenScaler extends StatelessWidget {
  const SmallScreenScaler({required this.child, super.key});

  /// The shorter viewport side is stretched to this design size before rendering.
  static const double minDesignSide = 360;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final real = MediaQueryData.fromView(View.of(context));
    final realMinSide = math.min(real.size.width, real.size.height);
    if (realMinSide >= minDesignSide) {
      return child;
    }
    final scale = realMinSide / minDesignSide;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: real.size.width / scale,
        height: real.size.height / scale,
        child: MediaQuery(
          data: real.copyWith(
            size: real.size / scale,
            devicePixelRatio: real.devicePixelRatio * scale,
            padding: real.padding / scale,
            viewPadding: real.viewPadding / scale,
            viewInsets: real.viewInsets / scale,
            systemGestureInsets: real.systemGestureInsets / scale,
          ),
          child: child,
        ),
      ),
    );
  }
}
