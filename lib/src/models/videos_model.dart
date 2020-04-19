class VideosModelList {
  List<VideosModel> items = List();

  fromJsonList(List list) {
    list.forEach((item) {
      items.add(VideosModel.fromJson(item));
    });
  }
}

class VideosModel {
  String id;
  String url;
  String title;

  VideosModel({
    this.id,
    this.url,
    this.title,
  });

  factory VideosModel.fromJson(Map<String, dynamic> json) => VideosModel(
        id: json["id"],
        url: json["url"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "title": title,
      };
}
