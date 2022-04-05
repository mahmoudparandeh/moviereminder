import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:moviereminder/helper/colors.dart';

class Loading extends StatelessWidget {
  const Loading({
    required this.child,
    required this.isLoading,
    this.color = primaryColor,
    this.isFullWidth = false,
    this.size = 50.0,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final bool isLoading;
  final Color color;
  final double size;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return isLoading
        ? Container(
        alignment: Alignment.center,
        height: isFullWidth ? height: 300,
        color: backgroundMainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Lottie.asset('assets/json/loading.json',width: 150),
            Padding(padding: const EdgeInsets.only(top: 0, right: 28, left: 28),
                child: Text('loading movies...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 28)),)),
          ],
        )
    )
        : child;
  }
}
