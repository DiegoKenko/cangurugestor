import 'package:flutter/cupertino.dart';

class AnimatedPageTransition extends PageRouteBuilder {
  final Widget page;
  AnimatedPageTransition({
    required this.page,
  }) : super(
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 500),
        );
}
