import 'dart:core';
class Picture {
  String title;
  String date;
  String url;
  String type;

  Picture.fromJson(Map json) :
        title = json["title"].toString().split("\n").first,
        date = json["date"],
        url = json["thumbnail_url"]??json["url"],
        type = json["media_type"];
}
