import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviereminder/model/artist.model.dart';
import 'package:moviereminder/widget/glassmorphism.dart';

class Artist extends StatelessWidget {
  final ArtistModel artist;

  const Artist({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Glassmorphism(
            child: CachedNetworkImage(
              imageUrl: artist.image,
              fit: BoxFit.fill,
              width: 64,
              height: 64,
            ),
            borderRadius: 50,
            width: 64,
            height: 64,
            border: 1),
        Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(
          artist.realName,
          style: GoogleFonts.openSans(
              textStyle: const TextStyle(fontSize: 16, color: Colors.white)),
        ),),
        Text(
          artist.movieName,
          style: GoogleFonts.openSans(
              textStyle: const TextStyle(fontSize: 12, color: Color(0xffaeaeae))),
        )
      ],
    );
  }
}
