import 'package:moviereminder/model/score.model.dart';

import '../../model/genre.model.dart';

List<GenreModel> getGenres() {
  List<GenreModel> genres = [];
  genres.add(GenreModel(id: 1, title: "drama", image: "assets/images/drama.png"));
  genres.add(GenreModel(id: 2, title: "comedy", image: "assets/images/comedy.png"));
  genres.add(GenreModel(id: 3, title: "thriller", image: "assets/images/thriller.png"));
  genres.add(GenreModel(id: 4, title: "romance", image: "assets/images/romance.png"));
  genres.add(GenreModel(id: 5, title: "action", image: "assets/images/action.png"));
  genres.add(GenreModel(id: 6, title: "crime", image: "assets/images/crime.png"));
  genres.add(GenreModel(id: 7, title: "horror", image: "assets/images/horror.png"));
  genres.add(GenreModel(id: 8, title: "adventure", image: "assets/images/adventure.png"));
  genres.add(GenreModel(id: 9, title: "sci-fi", image: "assets/images/sci-fi.png"));
  genres.add(GenreModel(id: 10, title: "fantasy", image: "assets/images/fantasy.png"));
  genres.add(GenreModel(id: 11, title: "animation", image: "assets/images/animation.png"));
  genres.add(GenreModel(id: 12, title: "music", image: "assets/images/music.png"));
  genres.add(GenreModel(id: 13, title: "western", image: "assets/images/western.png"));
  genres.add(GenreModel(id: 14, title: "magic", image: "assets/images/magic.png"));
  return genres;
}

List<ScoreModel> getScores() {
  List<ScoreModel> scores = [];
  scores.add(ScoreModel(score: 9, title: "upper than 9"));
  scores.add(ScoreModel(score: 8, title: "upper than 8"));
  scores.add(ScoreModel(score: 7, title: "upper than 7"));
  scores.add(ScoreModel(score: 6, title: "upper than 6"));
  scores.add(ScoreModel(score: 5, title: "upper than 5"));
  return scores;
}

List<String> getTypes() {
  List<String> types = [];
  types.add('movie');
  types.add('series');
  types.add('anime');
  return types;
}
