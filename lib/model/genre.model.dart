class GenreModel {
  late int id;
  late String title;
  late String image;

  GenreModel({required this.id, required this.title, required this.image});

  GenreModel.fromJSON(Map data) {
    id = data["id"] ?? 0;
    title = data["slug"];
    image = data["slug"]+".png";
  }
}