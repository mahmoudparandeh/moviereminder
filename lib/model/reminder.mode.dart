import 'package:intl/intl.dart';
import 'package:moviereminder/model/movie.model.dart';

class ReminderModel {
  late int id;
  late String date;
  late String title;
  late String interval;
  late String description;
  late MovieModel movie;

  ReminderModel();

  ReminderModel.fromJson(Map data) {
    id = data["id"];
    DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(data["startDate"], true).toLocal();
    var splitDate = dateTime.toString().split(' ');
    date = splitDate[0]+ ' ' + splitDate[1].toString().substring(0,5);
    title = data["title"];
    description = data["description"];
    interval = data["interval"].toString();
    movie = MovieModel();
    movie.title = data["name"];
    movie.id = data["movieId"];
    movie.imdbScore = data["imdbRate"].toString();
    movie.bigImage = data["image"];
  }
}