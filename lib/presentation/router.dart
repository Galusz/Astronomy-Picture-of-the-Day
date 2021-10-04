import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astronomy_picture/constants/strings.dart';
import 'package:astronomy_picture/cubit/app_cubit.dart';
import 'package:astronomy_picture/data/services/file_service.dart';
import 'package:astronomy_picture/data/services/network_service.dart';

import 'package:astronomy_picture/data/models/picture.dart.';

import 'package:astronomy_picture/data/repository.dart';
import 'package:astronomy_picture/presentation/screens/favourite_screen.dart';
import 'package:astronomy_picture/presentation/screens/list_screen.dart';

class AppRouter {
  Repository repository;
  AppCubit appCubit;

  AppRouter() {
    repository = Repository(networkService: NetworkService(),fileService: FileService());
    appCubit = AppCubit(repository: repository);
  }

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: appCubit,
            child: ListScreen(),
          ),
        );
      case FAVOURITE_ROUTE:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: appCubit,
            child: FavouriteScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
