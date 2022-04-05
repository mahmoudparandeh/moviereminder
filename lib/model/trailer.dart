class Trailer {
  late String cover;
  late String link;

  Trailer.fromJSON(Map data) {
    cover = data["cover"];
    link = data["link"];
  }
}