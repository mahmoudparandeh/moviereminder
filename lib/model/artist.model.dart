class ArtistModel {
  late String realName;
  late String movieName;
  late String image;

  ArtistModel.fromJSON(Map data) {
    realName = data["name"];
    movieName = data["as"];
    image = data["image"];
  }

}