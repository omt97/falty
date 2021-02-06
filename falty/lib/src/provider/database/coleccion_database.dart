import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falty/src/models/coleccion_model.dart';
import 'package:falty/src/models/item_model.dart';
import 'package:falty/src/models/user_model.dart';

class ColeccionDatabaseProvider {

  String uid;
  ColeccionDatabaseProvider(/*{@required this.uid}*/);

  //collection reference
  final CollectionReference dbColecciones = FirebaseFirestore.instance.collection('coleccion');

  //obtener colecciones de la db
  Future<List<Coleccion>> colecciones() async {

    List<Coleccion> colecciones = [];

    await dbColecciones.orderBy('titulo').limit(10).get().then((value){

      value.docs.forEach((element) {
        Coleccion coleccion = _crearColeccion(element.data(), [], [], element.id);
        colecciones.add(coleccion);
      });

    });

    return colecciones;

  }

  //obtener colecciones de la db 
  Future<List<Coleccion>> coleccionesRecomendadas() async{

    List<Coleccion> colecciones = [];

    await dbColecciones.orderBy('titulo').limit(10).get().then((value){

      value.docs.forEach((element) {
        Coleccion coleccion = _crearColeccion(element.data(), [], [], element.id);
        colecciones.add(coleccion);
      });

    });

    return colecciones;
  }

  //obtener colecciones de la db
  Future<List<Coleccion>> coleccionesRecientes() async{

    List<Coleccion> colecciones = [];

    await dbColecciones.orderBy('fecha').limit(10).get().then((value){

      value.docs.forEach((element) {
        Coleccion coleccion = _crearColeccion(element.data(), [], [], element.id);
        colecciones.add(coleccion);
      });

    });

    return colecciones;

  }

  //obtener colecciones de la db
  Future<List<Coleccion>> coleccionesPopulares() async{

    List<Coleccion> colecciones = [];

    await dbColecciones.orderBy('numseguidores').limit(10).get().then((value){

      value.docs.forEach((element) {
        Coleccion coleccion = _crearColeccion(element.data(), [], [], element.id);
        colecciones.add(coleccion);
      });

    });

    return colecciones;

  }

  //obtener colecciones de la db
  Future<List<Coleccion>> coleccionesSearch(String word) async{

    List<Coleccion> colecciones = [];

    print(word);

    await dbColecciones.orderBy('titulo').startAt([word]).endAt([word+'\uf8ff']).get().then((value){

      value.docs.forEach((element) {
        print('hfghj');
        Coleccion coleccion = _crearColeccion(element.data(), [], [], element.id);
        colecciones.add(coleccion);
      });

    });

    return colecciones;
  }

  //obtener colecciones de la db
  Future<Coleccion> coleccion(String uid) async{

    List<String> seguidores = [];

    await dbColecciones.doc(uid).collection('seguidores').get().then((value) {

      value.docs.forEach((element) { 
        print(element.id);
        seguidores.add(element.id);
      });
    });

    print(seguidores);

    List<String> items = [];

    await dbColecciones.doc(uid).collection('items').get().then((value) {

      value.docs.forEach((element) { 
        items.add(element.id);
      });
    });

    Coleccion coleccion;

    await dbColecciones.doc(uid).get().then((value){
      coleccion = _crearColeccion(value.data(), seguidores, items, uid);
    });

    return coleccion;

  }

  //crear coleccion
  Future<String> crearColeccion(Coleccion coleccion) async {

    String idColeccion;

    await dbColecciones
      .add({
        'titulo'        : coleccion.titulo,
        'descripcion'   : coleccion.descripcion,
        'foto'          : coleccion.foto,
        'fecha'         : coleccion.fecha,
        'empresa'       : coleccion.empresa,
        'total'         : coleccion.total,
        'numseguidores' : coleccion.numseguidores,
        'numitems'      : coleccion.numitems
      }).then((value) {
        idColeccion = value.id;
      });

    return idColeccion;
  }

  //crear items de coleccion
  Future crearItemsColeccion(List<Item> items) async{

    List<String> uidItems = [];

    for (int i = 0; i < items.length; ++i){
      await FirebaseFirestore.instance.collection('items').add({
        'uidColeccion'    : items[i].uidColeccion,
        'nombreColeccion' : items[i].nombreColeccion,
        'numero'          : items[i].numero,
        'informacion'     : items[i].informacion,
        'foto'            : items[i].foto,
      }).then((value) {
        uidItems.add(value.id);
      });
    }

    for (int i = 0; i < uidItems.length; ++i){
      await dbColecciones.doc(uidItems[i]).set({});
    }

  }


  //existe coleccion
  Future<bool> existeColeccion(String uid) async{
    await dbColecciones.doc(uid).get().then((value) {
      return (value.data() != null);
    });

    return false;
  }

  //obtener colecciones (lista id como las que sigue alguien)
  Future<List<Coleccion>> coleccionesIds(List<String> coleccionesIds) async{
    print('las uid : ' + coleccionesIds.toString());
    List<Coleccion> colecciones = [];

    for (int i = 0; i < coleccionesIds.length; i++){
      await dbColecciones.doc(coleccionesIds[i]).get().then((value) {
        Coleccion coleccion = _crearColeccion(value.data(), [], [], value.id);
        colecciones.add(coleccion);
      });
    }

    return colecciones;
    
  }

  //eliminar coleccion
  Future eliminarColeccion(String uid) async{
    await dbColecciones.doc(uid).delete(); 
  }

  //modificar coleccion

  //añadir seguidor
  Future nuevoSeguidor(String uidColeccion, String uidUser) async{

    await dbColecciones.doc(uidColeccion).update({
      'numseguidores' : FieldValue.increment(1)
    });

    await dbColecciones.doc(uidColeccion).collection('seguidores').doc(uidUser).set({});

  }

  //quitar seguidor
    Future quitarSeguidor(String uidColeccion, String uidUser) async{

    await dbColecciones.doc(uidColeccion).update({
      'numseguidores' : FieldValue.increment(-1)
    });

    await dbColecciones.doc(uidColeccion).collection('seguidores').doc(uidUser).delete();

  }


  //TODO añadir item

  //TODO quitar item


  Coleccion _crearColeccion(Map<String, dynamic> data, List<String> seguidores, List<String> items, String id) {

    return new Coleccion(
      uid           : id,
      titulo        : data['titulo'],
      descripcion   : data['descripcion'],
      foto          : data['foto'],
      fecha         : data['fecha'],
      empresa       : data['empresa'],
      total         : data['total'],
      numseguidores : data['numseguidores'],
      numitems      : data['numitems'],
      seguidores    : seguidores,
      items         : items,

    );

  }


  Future<String> crearColeccionesHardData() async {

    String idColeccion;

    for(int i = 0; i < 10; ++i){

    await dbColecciones
      .add({
        'titulo'        : i.toString(),
        'descripcion'   : i.toString(),
        'foto'          : 'assets/gorm.jpg',
        'fecha'         : i.toString(),
        'empresa'       : i.toString(),
        'total'         : i,
        'numseguidores' : i,
        'numitems'      : i
      }).then((value) {
        idColeccion = value.id;
      });
    }

    return idColeccion;
  }

}