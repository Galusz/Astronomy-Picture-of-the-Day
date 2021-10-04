import 'package:astronomy_picture/data/models/favourite_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astronomy_picture/cubit/app_cubit.dart';
import '../../app_localizations.dart';
import 'dart:io';



class FavouriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AppCubit>(context).fetchFavPicturesList();

    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<AppCubit>(context).fetchPicturesList();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).translate('favourite_list')),
          ),
          body: BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {

              if (!(state is PictureFavListLoaded))
                return Center(child: CircularProgressIndicator());

              final pictures = (state as PictureFavListLoaded).pictureFavList;

              return ListView(
                  children:pictures.map((e) => _pictureItem(e, context)).toList()
              );
            },
          )),
    );
  }

  Widget _pictureItem(FavouritePicture picture, context) {
    return  Card(
      child: Container(
        height: 120,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Material(
                child: Image.file(
                  File(picture.path),
                  errorBuilder: (context, object, stackTrace) {
                    return Icon(
                      Icons.image,
                      size: 100,
                    );
                  },
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[

                        Text(
                          picture.date,
                          style: TextStyle(color: Colors.grey,
                              fontSize: 8),
                        ),
                        Text(
                          picture.title,
                          maxLines: 5,
                          style: TextStyle(color: Colors.black,
                              fontSize: 20),
                        ),
                      ]
                  ),
                ),
              ),
              IconButton(onPressed: ()=> BlocProvider.of<AppCubit>(context).deletePictureFromFav(picture), icon: Icon(Icons.delete)),
            ]
        ),
      ),
    );
  }
}
