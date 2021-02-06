import 'package:falty/src/bloc/coleccion_bloc.dart';
import 'package:falty/src/bloc/user_bloc.dart';
import 'package:falty/src/models/coleccion_model.dart';
import 'package:falty/src/pages/colecciones/colecciones_page.dart';
import 'package:falty/src/pages/colecciones/coleccion_page.dart';
import 'package:falty/src/pages/navigation/profile/usuario_page.dart';
import 'package:falty/src/util/animations.dart';
import 'package:falty/src/widgets/barra_buscadora.dart';
import 'package:falty/src/widgets/lista_colecciones.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  final UserBloc _userBloc = UserBloc();
  final ColeccionBloc _coleccionBloc = ColeccionBloc();

  @override
  Widget build(BuildContext context) {

    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    double heightList = heightScreen/3.75;

    _coleccionBloc.obtenerColecciones();

    return Container(
        padding: EdgeInsets.all(0),
        width: widthScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BarraBuscadora(),
            list(heightList, widthScreen, "Colecciones mas populares", context, _coleccionBloc.coleccionesPopularesStream),
            list(heightList, widthScreen, "Colecciones mas recientes", context, _coleccionBloc.coleccionesRecientesStream),
            list(heightList, widthScreen, "Colecciones mas recomendadas", context, _coleccionBloc.coleccionesRecomendadasStream),
          /*  Image.network(_userBloc.userModel.photo),
            Text('Name: ' + _userBloc.userModel.name),
            Text('Nick: ' + _userBloc.userModel.nick),
            Text('Id: ' + _userBloc.userModel.uid.toString()),*/
        ],
        ),
      );
  }

}