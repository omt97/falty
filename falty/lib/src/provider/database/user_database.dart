import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falty/src/models/user_model.dart';

class DatabaseProvider {

  String uid;
  DatabaseProvider(/*{@required this.uid}*/);

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

  //TODO modificar usuario

  //TODO borrar usuario


}