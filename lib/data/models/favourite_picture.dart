class FavouritePicture {
  String title;
  String date;
  String path;
  String url;

  FavouritePicture(this.title, this.date, this.path, this.url);

  FavouritePicture.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        date = json['date'],
        path = json['path'],
        url = json['url'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'date': date,
    'path': path,
    'url': url,
  };
}