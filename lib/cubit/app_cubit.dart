import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:astronomy_picture/data/models/picture.dart';
import 'package:astronomy_picture/data/models/favourite_picture.dart';
import 'package:astronomy_picture/data/repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final Repository repository;

  AppCubit({this.repository}) : super(AppInitial());

  void fetchPicturesList() {
    repository.fetchPicturesList().then((pictures) {
      if(pictures.isEmpty){
        emit(NetworkFail());}
      else {
        emit(PictureListLoaded(pictureList: pictures));
      }
    });
  }

  void fetchFavPicturesList() {
    repository.loadPictureList().then((pictures) {
      emit(PictureFavListLoaded(pictureFavList: pictures));
    });
  }

  void addPictureToFav(Picture picture) {
    repository.loadPictureList().then((list) {
      var contain = list.where((element) => element.url == picture.url);
      if (contain.isNotEmpty) {
      }
      else {
        repository.savePicture(picture.url).then((localPath) {
          if (localPath.isNotEmpty) {
            var fav = new FavouritePicture(
                picture.title, picture.date, localPath, picture.url);
            list.add(fav);
            repository.savePictureList(list);
          }
        });
      }
      emit(PictureAdded(pictureUrl: picture.url));
    });
  }

  void deletePictureFromFav(FavouritePicture picture) {
    repository.loadPictureList().then((list) {
      var newList = list.where((element) => element.url != picture.url).toList();
      repository.savePictureList(newList).then((response) {
        if (response)
          emit(PictureFavListLoaded(pictureFavList: newList));
      });
    });
  }
}
