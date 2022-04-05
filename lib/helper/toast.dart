import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Toast {

  static Color successColor = const Color(0xFF009944);
  static Color warningColor = const Color(0xFFf0541e);
  static Color errorColor = const Color(0xFFcf000f);
  static Color infoColor = const Color(0xFF63c0df);
  static Color niceWhite = const Color(0xFFFEF4E8);

  static ToastFuture success(message, {time = 3}) {
    return showToast(message.toString(),
        animation: StyledToastAnimation.slideFromTop,
        reverseAnimation: StyledToastAnimation.slideToTop,
        position: StyledToastPosition.top,
        startOffset: const Offset(0.0, -3.0),
        reverseEndOffset: const Offset(0.0, -3.0),
        duration: Duration(seconds: time),
        animDuration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        textDirection: TextDirection.ltr,
        backgroundColor: successColor,
        reverseCurve: Curves.fastOutSlowIn);
  }

  static ToastFuture error(message) {
    return showToast(message.toString(),
        animation: StyledToastAnimation.slideFromTop,
        reverseAnimation: StyledToastAnimation.slideToTop,
        position: StyledToastPosition.top,
        startOffset: const Offset(0.0, -3.0),
        reverseEndOffset: const Offset(0.0, -3.0),
        duration: const Duration(seconds: 4),
        animDuration: const Duration(seconds: 1),
        textDirection: TextDirection.ltr,
        curve: Curves.elasticOut,
        backgroundColor: errorColor,
        reverseCurve: Curves.fastOutSlowIn);
  }

  static ToastFuture info(
      message,
      ) {
    return showToast(message.toString(),
        animation: StyledToastAnimation.slideFromTop,
        reverseAnimation: StyledToastAnimation.slideToTop,
        position: StyledToastPosition.top,
        startOffset: const Offset(0.0, -3.0),
        reverseEndOffset: const Offset(0.0, -3.0),
        duration: const Duration(seconds: 4),
        animDuration: const Duration(seconds: 1),
        textDirection: TextDirection.ltr,
        curve: Curves.elasticOut,
        backgroundColor: infoColor,
        reverseCurve: Curves.fastOutSlowIn);
  }

  static ToastFuture warning(message) {
    return showToast(message.toString(),
        animation: StyledToastAnimation.slideFromTop,
        reverseAnimation: StyledToastAnimation.slideToTop,
        position: StyledToastPosition.top,
        startOffset: const Offset(0.0, -3.0),
        reverseEndOffset: const Offset(0.0, -3.0),
        duration: const Duration(seconds: 4),
        animDuration: const Duration(seconds: 1),
        textDirection: TextDirection.ltr,
        curve: Curves.elasticOut,
        backgroundColor: warningColor,
        reverseCurve: Curves.fastOutSlowIn);
  }
}
