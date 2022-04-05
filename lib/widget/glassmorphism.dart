import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class Glassmorphism extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final double border;
  const Glassmorphism({Key? key, required this.child, required this.borderRadius,
    required this.width, required this.height, required this.border}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: width,
      height: height,
      borderRadius: borderRadius,
      blur: 7,
      alignment: Alignment.bottomCenter,
      border: border,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF000000).withAlpha(50),
            const Color(0xFF000000).withAlpha(50),
          ],
          stops: const [
            0.3,
            1,
          ]),
      borderGradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            const Color(0xFFC5A145).withAlpha(75),
            const Color(0xFFFFFFFF).withAlpha(35),
            const Color(0xFF000000).withAlpha(10),
          ],
          stops: const [
            0.06,
            0.95,
            1
          ]),
      child: child,
    );
  }

}