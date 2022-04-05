import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviereminder/helper/colors.dart';
import '../helper/navigator.dart';
import '../model/movie.model.dart';
import '../screen/movie.detail.screen.dart';
import 'glassmorphism.dart';

class Top10 extends StatelessWidget {
  final MovieModel movie;

  const Top10({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      child: Glassmorphism(
        border: 1,
        width: width,
        borderRadius: 10,
        height: 175,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            CachedNetworkImage(
              imageUrl: movie.bigImage,
              fit: BoxFit.cover,
              width: width,
              height: 175,
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
                                textStyle: TextStyle(
                              fontSize: 14,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1
                                ..color = primaryColor,
                            )))
                      ],
                    ),
                  ),
                  borderRadius: 8,
                  width: 70,
                  border: 1,
                  height: 24),
              top: 4,
              right: 4,
            ),
            Positioned(
              child: Glassmorphism(
                  child: SizedBox(
                    height: 35,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       Container(
                         margin: const EdgeInsets.symmetric(horizontal: 8),
                         width: width-36,
                         child:  Text(movie.title,
                             overflow: TextOverflow.ellipsis,
                             textAlign: TextAlign.center,
                             style: GoogleFonts.lato(
                                 textStyle: const TextStyle(
                                   fontSize: 14,
                                   color: Colors.white
                                 ))),
                       )
                      ],
                    ),
                  ),
                  borderRadius: 0,
                  border: 0,
                  width: width-20,
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
