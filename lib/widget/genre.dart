import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviereminder/helper/colors.dart';
import 'package:moviereminder/helper/navigator.dart';
import 'package:moviereminder/model/genre.model.dart';
import 'package:moviereminder/screen/search.screen.dart';
import 'package:moviereminder/widget/glassmorphism.dart';

class Genre extends StatelessWidget{
  final GenreModel genre;
  const Genre({Key? key, required this.genre}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(child: Glassmorphism(
      width: 128,
      border: 1,
      height: 120,
      borderRadius: 10,
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(10),
          child: Image.asset(genre.image, width: 64,)),
          Text(genre.title, style: GoogleFonts.petitFormalScript(textStyle: const TextStyle(color: primaryColor, fontSize: 16)))
        ],
      ),
    ),
    enableFeedback: true,
    borderRadius: BorderRadius.circular(10),
    onTap: () {
      Navigator.push(context, SlideBottomRoute(page: SearchScreen(searchType: "", genreSearch: genre.id,)));
    },);
  }

}