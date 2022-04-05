
import 'package:moviereminder/model/artist.model.dart';
import 'package:moviereminder/model/trailer.dart';

import 'genre.model.dart';

class MovieModel {
  late int id;
  late String title;
  late String description;
  late String imdbScore;
  late String imdbVotes;
  late String thumbnail;
  late String bigImage;
  List<GenreModel> genres = [];
  late String link;
  late bool isTV;
  List<ArtistModel> casts = [];
  List<Trailer> trailers = [];

  MovieModel() {
    id = 0;
    title = '';
    description = '';
    imdbScore = '';
    imdbVotes = '';
    thumbnail = '';
    bigImage = '';
    genres = [];
    link = '';
    isTV = false;
    casts = [];
  }

  MovieModel.fromJSON(Map data) {
    id = data["id"];
    title = data["title"];
    description = data["englishPlot"];
    imdbScore = data["imdbScore"].toString() != '' ? data["imdbScore"].toString() : "N/A";
    imdbVotes = data["imdbVotes"].toString() != '' ? data["imdbVotes"].toString() : "N/A";
    thumbnail = data["image"]["poster"];
    bigImage = data["image"]["cover"];
    data["genres"].forEach((element) {
      GenreModel genre = GenreModel.fromJSON(element);
      genres.add(genre);
    });
    isTV = data["isSeries"];
  }

  MovieModel.fromJsonComplex(Map data) {
    id = data["id"];
    title = data["title"];
    description = data["plot"];
    imdbScore = data["imdbScore"].toString() != '' ? data["imdbScore"].toString() : "N/A";
    imdbVotes = data["imdbVotes"].toString() != '' ? data["imdbVotes"].toString() : "N/A";
    thumbnail = data["image"]["poster"];
    bigImage = data["image"]["cover"];
    data["genres"].forEach((element) {
      GenreModel genre = GenreModel.fromJSON(element);
      genres.add(genre);
    });
    isTV = data["isSeries"];
    data["actors"].forEach((element) {
      ArtistModel artist = ArtistModel.fromJSON(element);
      casts.add(artist);
    });

    if(data["trailers"] != null) {
      data["trailers"].forEach((element) {
        Trailer trailer = Trailer.fromJSON(element);
        trailers.add(trailer);
      });
    }

  }
}