import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviereminder/helper/navigator.dart';
import 'package:moviereminder/screen/movie.detail.screen.dart';
import '../model/movie.model.dart';
import 'glassmorphism.dart';

class Movie extends StatelessWidget{
  final MovieModel movie;
  const Movie({Key? key, required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      child: Glassmorphism(
        width: width/2-10,
        border: 2,
        borderRadius: 10,
        height: width/2+100,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            CachedNetworkImage(
              imageUrl: movie.thumbnail,
              fit: BoxFit.cover,
              width: width/2-10,
              height: width/2+100,
              placeholder: (buildContext, url) =>
              const Center(child: CircularProgressIndicator(),),
            ),
            Positioned(
              child: Glassmorphism(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/imdb.png',
                          width: 35,
                        ),
                        Text(movie.imdbScore,
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                )))
                      ],
                    ),
                  ),
                  borderRadius: 8,
                  border: 1,
                  width: 70,
                  height: 24),
              top: 4,
              right: 4,
            ),
            Positioned(
              child: Glassmorphism(
                  child: Container(
                    alignment: Alignment.center,
                    width: width,
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(movie.title,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color : Colors.white
                            ))),
                  ),
                  borderRadius: 0,
                  border: 0,
                  width: width/2-10,
                  height: 35),
              bottom: 0,
            )
          ],
        ),
      ),
      enableFeedback: true,
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.push(context, SlideLeftRoute(page: MovieDetailScreen(movieId: movie.id)));
      },
    );
  }

}