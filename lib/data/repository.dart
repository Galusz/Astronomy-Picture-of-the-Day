import 'package:astronomy_picture/data/models/favourite_picture.dart';
import 'package:astronomy_picture/data/models/picture.dart';
import 'package:astronomy_picture/data/services/network_service.dart';
import 'package:astronomy_picture/data/services/file_service.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;

class Repository {
  final FileService fileService;
  final NetworkService networkService;

  Repository({this.networkService, this.fileService});

  Future<List<Picture>> fetchPicturesList() async {
    final raw = await networkService.fetchPicturesList();
    return raw.map((e) => Picture.fromJson(e)).toList();
  }

  Future<String> savePicture(url) async {
    final imageName = path.basename(url);
    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    final localPath = path.join(appDir.path, imageName);
    final image = await networkService.downloadPicture(url);
    if (image.length > 1) {
      final response = await fileService.savePicture(image, localPath);
      if (response) return localPath;
    }
      return "";
  }

  Future<bool> savePictureList(favouriteList) async {
    final response = await fileService.savePictureList(favouriteList);
    return response;
  }

  Future<List<FavouritePicture>> loadPictureList() async {
    print("load");
    final list = await fileService.loadPictureList();
    return list;
  }
}
