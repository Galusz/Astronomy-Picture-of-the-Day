part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class PictureListLoaded extends AppState {
  final List<Picture> pictureList;
  PictureListLoaded({this.pictureList});
}

class NetworkFail extends AppState {}


class PictureFavListLoaded extends AppState {
  final List<FavouritePicture> pictureFavList;
  PictureFavListLoaded({this.pictureFavList});
}

class PictureAdded extends AppState {
  final String pictureUrl;
  PictureAdded({this.pictureUrl});
}
