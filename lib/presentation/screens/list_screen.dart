import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astronomy_picture/constants/strings.dart';
import 'package:astronomy_picture/cubit/app_cubit.dart';
import 'package:astronomy_picture/data/models/picture.dart';
import '../../app_localizations.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AppCubit>(context).fetchPicturesList();

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('title')),
          actions: [
            InkWell(
              onTap: () => Navigator.pushNamed(context, FAVOURITE_ROUTE),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(width: 5),
                    Text(AppLocalizations.of(context).translate('favourite_list'),textAlign: TextAlign.center,)
                  ],
                ),
              ),
            )
          ],
        ),
        body: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            print(state);
            if(state is PictureAdded){
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context).translate('picture_added'),style: TextStyle(color: Colors.black,
                      fontSize: 20)),
                  SizedBox(height: 10),
                  Material(
                    child: Image.network(
                      state.pictureUrl,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 300,
                          height: 300,
                          child: Center(

                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null &&
                                  loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return Icon(
                          Icons.image,
                          size: 50,
                        );
                      },
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  SizedBox(height: 10),
                  TextButton(onPressed: ()=> BlocProvider.of<AppCubit>(context).fetchPicturesList(), child:Text(AppLocalizations.of(context).translate('picture_back')))
                ],
              ));
            }

            if(state is NetworkFail)
            {
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context).translate('network_fail'),style: TextStyle(color: Colors.black,
                      fontSize: 20)),
                  SizedBox(height: 10),

                  TextButton(onPressed: ()=> BlocProvider.of<AppCubit>(context).fetchPicturesList(), child:Text(AppLocalizations.of(context).translate('network_refresh'))),
                ],
              ));
            }

            if (!(state is PictureListLoaded))
              return Center(child: CircularProgressIndicator());

            final pictures = (state as PictureListLoaded).pictureList;

            return ListView(
                children:pictures.map((e) => _pictureItem(e, context)).toList()
            );
          },
        ));
  }

  Widget _pictureItem(Picture picture, context) {
    return  Card(
      child: Container(
        height: 120,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Material(
                child: Image.network(
                  picture.url??'',
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 100,
                      height: 100,
                      child: Center(

                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null &&
                              loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      ),
                    );
                  },
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
              IconButton(onPressed: ()=> BlocProvider.of<AppCubit>(context).addPictureToFav(picture), icon: Icon(Icons.favorite_outline)),
            ]
        ),
      ),
    );
  }
}
