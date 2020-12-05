import 'dart:async';

import 'package:falty/src/models/coleccion_model.dart';
import 'package:falty/src/provider/auth.dart';
import 'package:falty/src/provider/database/coleccion_database.dart';
import 'package:falty/src/provider/database/user_database.dart';

class ColeccionBloc {

  Coleccion coleccion;

  static final ColeccionBloc _singleton = new ColeccionBloc._internal();

  final AuthProvider authProvider = new AuthProvider();

  factory ColeccionBloc(){
    return _singleton;
  }

  ColeccionBloc._internal();

  //bloc de colecciones
  final _coleccionesController = StreamController<List<Coleccion>>.broadcast();
  //bloc colecciones recomendadas
  final _coleccionesRecomendadasController = StreamController<List<Coleccion>>.broadcast();
  //bloc colecciones ultimas añadidas
  final _coleccionesRecientesController = StreamController<List<Coleccion>>.broadcast();
  //bloc colecciones populares
  final _coleccionesPopularesController = StreamController<List<Coleccion>>.broadcast();
  //bloc coleccion actual
  final _coleccionController = StreamController<Coleccion>.broadcast();

  //obtener colecciones
  Stream<List<Coleccion>> get coleccionesStream => _coleccionesController.stream;
  //obtener colecciones recomendadas
  Stream<List<Coleccion>> get coleccionesRecomendadasStream => _coleccionesRecomendadasController.stream;
  //obtener colecciones recientes
  Stream<List<Coleccion>> get coleccionesRecientesStream => _coleccionesRecientesController.stream;
  //obtener colecciones populares
  Stream<List<Coleccion>> get coleccionesPopularesStream => _coleccionesPopularesController.stream;
  //obtener coleccion actual
  Stream<Coleccion> get coleccionStream => _coleccionController.stream;

  dispose(){
    _coleccionesController?.close();
    _coleccionesRecomendadasController?.close();
    _coleccionesRecientesController?.close();
    _coleccionesPopularesController?.close();
    _coleccionController?.close();
  }

  //TODO obtener colecciones (hacer el sink add de los streams)
  Future obtenerColecciones() async{
    _coleccionesController.sink.add(await ColeccionDatabaseProvider().colecciones());
    _coleccionesRecomendadasController.sink.add(await ColeccionDatabaseProvider().coleccionesRecomendadas());
    _coleccionesRecientesController.sink.add(await ColeccionDatabaseProvider().coleccionesRecientes());
    _coleccionesPopularesController.sink.add(await ColeccionDatabaseProvider().coleccionesPopulares());
  }

  //TODO obtener colecciones search
  Future obtenerColeccionesSearch(String word) async{
    _coleccionesController.sink.add(await ColeccionDatabaseProvider().coleccionesSearch(word));
  }

  //TODO obtener coleccion
  Future obtenerColeccion(String uid) async{
    _coleccionController.sink.add(await ColeccionDatabaseProvider().coleccion(uid));
  }

  //TODO añadir coleccion (no se podra hacer directamente, revision de administradores) --> hay recompensa para el que lo haga
  //TODO editar coleccion (no se podra hacer directamente, revision de administradores) --> hay recompensa para el que lo haga
  //TODO editar item (no se podra hacer directamente, revision de administradores) --> hay recompensa para el que lo haga
  //TODO eliminar coleccion (no se podra hacer directamente, revision de administradores) --> hay recompensa para el que lo haga


}