import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;
import 'package:astronomy_picture/data/models/favourite_picture.dart';

class FileService {
  Future<bool> savePicture(Uint8List, localPath) async {
    try {
      final imageFile = File(localPath);
      await imageFile.writeAsBytes(Uint8List);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> savePictureList(List<FavouritePicture> favouriteList) async {
    try {
      final listName = path.basename("favouriteList");
      final appDir = await pathProvider.getApplicationDocumentsDirectory();
      final localPath = path.join(appDir.path, listName);
      final listFile = File(localPath);
      await listFile.writeAsString(jsonEncode(favouriteList),
          mode: FileMode.write, flush: true);
      return true;
    } catch (e) {
      print(e); //TODO: Error handling
      return false;
    }
  }

  Future<List<FavouritePicture>> loadPictureList() async {
    try {
      final listName = path.basename("favouriteList");
      final appDir = await pathProvider.getApplicationDocumentsDirectory();
      final localPath = path.join(appDir.path, listName);
      final listFile = new File(localPath);
      var list = jsonDecode(await listFile.readAsString()) as List;
      final List<FavouritePicture> favouriteList =
      list.map((e) => FavouritePicture.fromJson(e)).toList();
      return favouriteList;
    } catch (e) {
      print(e); //TODO: Error handling
      return [];
    }
  }
}
