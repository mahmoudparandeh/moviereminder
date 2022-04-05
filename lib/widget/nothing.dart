import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviereminder/helper/colors.dart';

class Nothing extends StatelessWidget{
  const Nothing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/images/nothing.png", width: 128,),
        Padding(padding: const EdgeInsets.only(top: 16), child: Text("No movies found!!", style: GoogleFonts.lato(
          textStyle: const TextStyle(color: primaryColor, fontSize: 20)
        ),),)
      ],
    );
  }
}