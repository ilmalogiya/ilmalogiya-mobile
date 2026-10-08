import "dart:ui";

import "package:flutter/material.dart";

class BottomNavBlurWidget extends StatelessWidget {
  const BottomNavBlurWidget({super.key, this.sigma = 10.0, this.alpha = 0.65});

  final double sigma;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.paddingOf(context).bottom;
    final bool isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    if (bottomPadding <= 0 || isKeyboardOpen) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: bottomPadding,
      child: IgnorePointer(
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor
                    .withValues(alpha: alpha),
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withValues(alpha: 0.05),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
