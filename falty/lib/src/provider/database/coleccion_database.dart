import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falty/src/models/coleccion_model.dart';
import 'package:falty/src/models/user_model.dart';

class ColeccionDatabaseProvider {

  String uid;
  ColeccionDatabaseProvider(/*{@required this.uid}*/);

  //collection reference
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //obtener colecciones de la db
  Future<List<Coleccion>> colecciones() async {

    CollectionReference collectionColeccion = db.collection('usuario');
    //TODO obtener colecciones
    return [];

  }

  //obtener colecciones de la db
  Future<List<Coleccion>> coleccionesRecomendadas() async{

    CollectionReference collectionColeccion = db.collection('usuario');
    //TODO obtener colecciones
    return [];
  }

  //obtener colecciones de la db
  Future<List<Coleccion>> coleccionesRecientes() async{

    CollectionReference collectionColeccion = db.collection('usuario');
    //TODO obtener colecciones
    return [];
  }

  //obtener colecciones de la db
  Future<List<Coleccion>> coleccionesPopulares() async{

    CollectionReference collectionColeccion = db.collection('usuario');
    //TODO obtener colecciones
    return [];
  }

  //obtener colecciones de la db
  Future<List<Coleccion>> coleccionesSearch(String word) async{

    CollectionReference collectionColeccion = db.collection('usuario');
    //TODO obtener colecciones
    return [];
  }

  //obtener colecciones de la db
  Future<Coleccion> coleccion(String uid) async{

    //TODO esto es un ejemplo de como seria el acceso a la db, pero hay que poner mas cosas

    CollectionReference collectionColeccion = db.collection('usuario');
    Coleccion coleccion = new Coleccion();

    await collectionColeccion.doc(uid).get().then((value) {

      coleccion = dataToColeccion(value.data());

    });

    return coleccion;
  }

  //convertir data de la db a model de coleccion
  Coleccion dataToColeccion(Map<String, dynamic> data) {
    //TODO 
    return new Coleccion();

  }


}