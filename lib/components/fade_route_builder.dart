import 'package:flutter/cupertino.dart';

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  FadeRouteBuilder({required Widget page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
