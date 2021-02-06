import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falty/src/models/user_model.dart';
import 'package:falty/src/provider/database/coleccion_database.dart';
import 'package:falty/src/util/tuples.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDatabaseProvider {

  //String uid;
  UserDatabaseProvider(/*{@required this.uid}*/);

  //collection reference
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //al crear usuario
  Future createUser(UserModel user) async{

    //uid = user.uid;

    ColeccionDatabaseProvider().crearColeccionesHardData();

    await db.collection('usuario').doc(user.uid).set({
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

  
  Future<bool> existUserNick(String nick) async{

    bool existe = false;

    await db.collection('usuario').where('nick', isEqualTo: nick).get().then((value) {
      if (value.docs.length > 0) existe = true;
    });
    
    return existe;

  }

  //obtener usuario
  Future<UserModel> getUser(String useruid) async{

    Map<String, dynamic> infoUsuario;
    List<String> seguidos = [];
    List<String> bloqueados = [];
    List<String> logros = [];
    List<String> colecciones = [];
    List<Tuple3<String, String, int>> items = []; 

    await db.collection('usuario')
      .doc(useruid).get().then((value) {
        if (value.data() == null) return null;
        infoUsuario = value.data();
      });

    await db.collection('usuario')
      .doc(useruid).collection('seguidos').get().then((value) {
        value.docs.forEach((element) {
          seguidos.add(element.get('uidUser'));
        });
      });

    await db.collection('usuario')
      .doc(useruid).collection('bloqueados').get().then((value) {
        value.docs.forEach((element) {
          bloqueados.add(element.get('uidUser'));
        });
      });

    await db.collection('usuario')
      .doc(useruid).collection('logros').get().then((value) {
        value.docs.forEach((element) {
          logros.add(element.get('uidLogro'));
        });
      });

    await db.collection('usuario')
      .doc(useruid).collection('colecciones').get().then((value) {
        value.docs.forEach((element) async{
          colecciones.add(element.get('uidColeccion'));
          await db.collection('usuario')
            .doc(useruid).collection('colecciones').doc(element.id).collection('items').get().then((value) {
              value.docs.forEach((elementItem) {
                items.add(new Tuple3(element.get('uidColeccion'), elementItem.get('uidItem'), elementItem.get('cantidadItem')) );
              });
          });
        });
      });

    print(colecciones);

    return _createUserModel(useruid, infoUsuario, seguidos, bloqueados, logros, colecciones, items);
  }
  
  Future<List<String>> getUserColecciones(useruid) async{

    List<String> colecciones = [];

    await db.collection('usuario')
      .doc(useruid).collection('colecciones').get().then((value) {
        value.docs.forEach((element) async{
          print('++++++ ' + element.get('uidColeccion'));
          colecciones.add(element.get('uidColeccion'));
        });
      });
    print(colecciones);
    return colecciones;
  }

  //comprovar si el usuario sigue la coleccion
  Future<bool> sigoColeccion(UserModel userModel, String uidColeccion) async{

    await db.collection('usuario')
      .doc(userModel.uid).collection('colecciones').doc(uidColeccion).get().then((value) { return (value.data() != null);});

  }

  //nueva coleccion usuario db
  Future seguirColeccion(UserModel userModel, String uidColeccion) async{

    await db.collection('usuario')
      .doc(userModel.uid).collection('colecciones').doc(uidColeccion).set({
        'uidColeccion': uidColeccion, 'favorita': false
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
  Future sumarItem(UserModel userModel, String uidColeccion, String uidItem, bool nuevo, int valor) async{
    
    if (!nuevo) {
      await db.collection('usuario')
      .doc(userModel.uid)
      .collection('colecciones')
      .doc(uidColeccion)
      .collection('items')
      .doc(uidItem)
      .update({
        'cantidadItem' : valor
      });
    }

    else {
      await db.collection('usuario')
      .doc(userModel.uid)
      .collection('colecciones')
      .doc(uidColeccion)
      .collection('items')
      .doc(uidItem)
      .set({
        'uidColeccion': uidColeccion,
        'uidItem': uidItem,
        'cantidadItem': 1
      });
    }

  }

  //restar un item a la colección
  Future restarItem(UserModel userModel, String uidColeccion, String uidItem, bool eliminado, int valor) async{

    if (!eliminado) {
      await db.collection('usuario')
      .doc(userModel.uid)
      .collection('colecciones')
      .doc(uidColeccion)
      .collection('items')
      .doc(uidItem)
      .update({
        'cantidadItem' : valor
      });
    }

    else {
      await db.collection('usuario')
      .doc(userModel.uid)
      .collection('colecciones')
      .doc(uidColeccion)
      .collection('items')
      .doc(uidItem)
      .delete();
    }

  }

  //borrar usuario
  Future deleteUser(UserModel user) async{

    await db.collection('usuario')
      .doc(user.uid).delete().then((value) => print('usuario borrado'));    

  }

  //seguir usuario
  Future followUser(UserModel user, String userId) async{

    await db.collection('usuario')
      .doc(user.uid).collection('seguidos').doc(userId).set({
        'uidUsuario' : userId
      });

  }

  //dejar de seguir usuario
  Future unfollowUser(UserModel user, String userId) async{

    await db.collection('usuario')
      .doc(user.uid).collection('seguidos').doc(userId).delete();

  }

  //modificar nick
  Future updateNick(UserModel user) async{

    await db.collection('usuario')
      .doc(user.uid).update({
        'nick': user.nick
      });

  }

  //modificar color
  Future updateColor(UserModel user) async{

    await db.collection('usuario')
      .doc(user.uid).update({
        'color': user.color
      });

  }

  //modificar foto
  Future updateFoto(UserModel user) async{

    await db.collection('usuario')
      .doc(user.uid).update({
        'photo': user.photo
      });

  }

  //bloquear usuario
  Future blockUser(UserModel user, String userId) async{

    await db.collection('usuario')
      .doc(user.uid).collection('bloqueados').doc(userId).set({
        'uidUsuario' : userId
      });

  }

  //desbloquear usuario
  Future unblockUser(UserModel user, String userId) async{

    await db.collection('usuario')
      .doc(user.uid).collection('bloqueados').doc(userId).delete();

  }

  //nuevo logro
  Future logro(UserModel user, String logroId) async{

    await db.collection('usuario')
      .doc(user.uid).collection('logros').doc(logroId).set({
        'uidLogro' : logroId
      });

  }

  //obtener usuarios (todos)
  Future<List<UserModel>> getUsers() async{

    List<UserModel> users = [];

    await db.collection('usuario').get().then((value) { 
      value.docs.forEach((element) async{
        users.add(await getUser(element.id));
      });
    });

    return users; 

  }

  //obtener usuarios (lista de id)
  Future<List<UserModel>> getUsersList(List<String> idUsers) async{

    List<UserModel> users = [];

    for (var i = 0; i < idUsers.length; i ++){
        users.add(await getUser(idUsers[i]));
    }

    return users; 

  }

  UserModel _createUserModel(String uid, Map<String, dynamic> data, List<String> seguidos, List<String> bloqueados, List<String> logros, List<String> colecciones, List<Tuple3<String, String, int>> items){

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