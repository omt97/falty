import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falty/src/models/user_model.dart';
import 'package:falty/src/util/tuples.dart';

class UserDatabaseProvider {

  String uid;
  UserDatabaseProvider(/*{@required this.uid}*/);

  //collection reference
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //al crear usuario
  Future createUser(UserModel user) async{

    uid = user.uid;

    return await db.collection('usuario').doc(user.uid).set({
      'nick': user.nick,
      'email': user.email,
      'name': user.name,
      'surname': user.surname,
      'color': user.color,
      'photo': user.photo
      /*'seguidos': ,
      'bloqueados': ,
      'logros': ,
      'colecciones': */
    }).then((value) {});
  }

  //existe user
  Future<bool> existUser(String uidUser) async{

    bool existe = false;

    await db.collection('usuario')
      .doc(uidUser).get().then((value) async{
        existe = (value.data() != null);
      });
    return existe;
  }

  //TODO obtener usuario
  Future<UserModel> getUser(UserModel user) async{

    Map<String, dynamic> infoUsuario;
    List<String> seguidos = [];
    List<String> bloqueados = [];
    List<String> logros = [];
    List<String> colecciones = [];
    List<Tuple3<String, String, int>> items = []; 

    await db.collection('usuario')
      .doc(user.uid).get().then((value) {
        if (value.data() == null) return null;
        infoUsuario = value.data();
      });

    await db.collection('usuario')
      .doc(user.uid).collection('seguidos').get().then((value) {
        value.docs.forEach((element) {
          seguidos.add(element.get('uidUser'));
        });
      });

    await db.collection('usuario')
      .doc(user.uid).collection('bloqueados').get().then((value) {
        value.docs.forEach((element) {
          bloqueados.add(element.get('uidUser'));
        });
      });

    await db.collection('usuario')
      .doc(user.uid).collection('logros').get().then((value) {
        value.docs.forEach((element) {
          logros.add(element.get('uidLogro'));
        });
      });

    await db.collection('usuario')
      .doc(user.uid).collection('colecciones').get().then((value) {
        value.docs.forEach((element) async{
          colecciones.add(element.get('uidColeccion'));
          await db.collection('usuario')
            .doc(user.uid).collection('colecciones').doc(element.id).collection('items').get().then((value) {
              value.docs.forEach((elementItem) {
                items.add(new Tuple3(element.get('uidColeccion'), elementItem.get('uidItem'), elementItem.get('cantidadItem')) );
              });
          });
        });
      });

    


    return _createUserModel(infoUsuario, seguidos, bloqueados, logros, colecciones, items);
  }

  
  //nueva coleccion usuario db
  Future seguirColeccion(UserModel userModel, String uidColeccion) async{

    await db.collection('usuario')
      .doc(userModel.uid).collection('colecciones').doc(uidColeccion).set({
        'uidColection': uidColeccion, 'favorita': false
      });

  }

  //dejar de seguir una coleccion
  Future noSeguirColeccion(UserModel userModel, String uidColeccion) async{

    await db.collection('usuario')
      .doc(userModel.uid).collection('colecciones').doc(uidColeccion).delete();

  }

  //marcar o desmarcar favorita una coleccion
  Future marcarColeccionFavorita(UserModel userModel, String uidColeccion, bool favorita) async{
    await db.collection('usuario')
      .doc(userModel.uid).collection('colecciones').doc(uidColeccion).update({
        'favorita': favorita
      });
  }

  //añadir un item de mas al cromo
  sumarItem(UserModel userModel, String uidColeccion, String uidItem, bool nuevo) {}

  restarItem(UserModel userModel, String uidColeccion, String uidItem, bool eliminado) {}

  //TODO modificar usuario

  //TODO borrar usuario


  UserModel _createUserModel(Map<String, dynamic> data, List<String> seguidos, List<String> bloqueados, List<String> logros, List<String> colecciones, List<Tuple3<String, String, int>> items){

    return new UserModel(
      uid: uid,
      nick: data['nick'],
      email: data['email'],
      name: data['name'],
      surname: data['surname'],
      color: data['color'],
      photo: data['photo'],
      seguidos: seguidos,
      bloqueados: bloqueados,
      logros: logros,
      colecciones: colecciones,
      items: items
    );

  }




}