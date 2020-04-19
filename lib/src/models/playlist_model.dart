class PlayListModelList {
  List<PlayListModel> items = List();

  fromJsonList(List list) {
    list.forEach((item) {
      items.add(PlayListModel.fromJson(item));
    });
  }
}

class PlayListModel {
  String url;
  String title;
  String id;

  PlayListModel({
    this.url,
    this.title,
    this.id,
  });

  factory PlayListModel.fromJson(Map<String, dynamic> json) => PlayListModel(
        url: json["url"],
        title: json["title"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "id": id,
      };
}
