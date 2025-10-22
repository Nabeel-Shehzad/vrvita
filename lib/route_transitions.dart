import 'package:flutter/material.dart';

Route slideToLeft(Widget page, {int ms = 450}) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: ms),
    reverseTransitionDuration: Duration(milliseconds: ms),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, secondary, child) {
      final offsetAnim = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic))
          .animate(animation);
      final fadeAnim = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return SlideTransition(position: offsetAnim, child: FadeTransition(opacity: fadeAnim, child: child));
    },
  );
}
