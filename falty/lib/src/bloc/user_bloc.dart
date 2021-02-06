import 'dart:async';

import 'package:falty/src/models/user_model.dart';
import 'package:falty/src/provider/auth.dart';
import 'package:falty/src/provider/database/coleccion_database.dart';
import 'package:falty/src/provider/database/user_database.dart';
import 'package:falty/src/util/tuples.dart';

class UserBloc {

  UserModel userModel;

  static final UserBloc _singleton = new UserBloc._internal();

  final AuthProvider authProvider = new AuthProvider();

  factory UserBloc(){
    return _singleton;
  }

  UserBloc._internal();

  //bloque de usuario
  final _userController = StreamController<UserModel>.broadcast();
  final _otherUserController = StreamController<UserModel>.broadcast();

  //obtener stream con info del bloque
  Stream<UserModel> get userStream => _userController.stream;
  Stream<UserModel> get otherUserStream => _otherUserController.stream;

  dispose(){
    _userController?.close();
    _otherUserController?.close();
  }

  //logout
  Future logout() async {
    await authProvider.googleSignout();
    _userController.sink.add(null);
  }

  //iniciar session con google
  Future<dynamic> loginWithGoogle() async{
    UserModel user = await authProvider.loginGoogle();

    if (user != null){

      bool existe = await UserDatabaseProvider().existUser(user.uid);
      if (!existe) {
        this.userModel = user;
        _userController.sink.add(user);
        //await UserDatabaseProvider().createUser(user);
      }
      else{
        this.userModel = await UserDatabaseProvider().getUser(user.uid);
        _userController.sink.add(this.userModel);
      }

    }

    return user;
  }

  Future recargarUser() async{
    print('guardando user');
    _userController.sink.add(this.userModel);
    print('guardado');
  }

  Future<dynamic> crearUsuario(UserModel userModel) async{
    _userController.sink.add(userModel);
    await UserDatabaseProvider().createUser(userModel);
    this.userModel = await UserDatabaseProvider().getUser(userModel.uid);
    _userController.sink.add(this.userModel);
    return userModel;
  }

  //comnprovar si sigo coleccion
  bool sigoColeccion(String uidColeccion) {
    for (int i = 0; i < userModel.colecciones.length; ++i){
      if (userModel.colecciones[i] == uidColeccion) return true;
    }
    return false;
  }

  //TODO seguir coleccion
  Future seguirColeccion(String uidColeccion) async{

    this.userModel.colecciones.add(uidColeccion);
    await UserDatabaseProvider().seguirColeccion(this.userModel, uidColeccion);
    await ColeccionDatabaseProvider().nuevoSeguidor(uidColeccion, this.userModel.uid);
    _userController.sink.add(this.userModel);

  }

  //TODO parar de seguir coleccion
  Future noSeguirColeccion(String uidColeccion) async{

    this.userModel.colecciones.remove(uidColeccion);
    await UserDatabaseProvider().noSeguirColeccion(this.userModel, uidColeccion);
    await ColeccionDatabaseProvider().quitarSeguidor(uidColeccion, this.userModel.uid);
    _userController.sink.add(this.userModel);

  }

  //TODO coleccion favorita
  Future favoritearColeccion(String uidColeccion, bool favorita) async{
    await UserDatabaseProvider().marcarColeccionFavorita(this.userModel, uidColeccion, favorita);
  }

  //TODO sumar item
  Future sumarItemColeccion(String uidColeccion, String uidItem) async{

    bool nuevo = true;
    int valor = 0;

    for (int i = 0; i < this.userModel.items.length; i++){
      if (this.userModel.items[i].item1 == uidColeccion){
        if (this.userModel.items[i].item2 == uidItem) {
          this.userModel.items[i].item3 += 1;
          valor = this.userModel.items[i].item3;
          nuevo = false;
        }
      }
    }

    if (nuevo) this.userModel.items.add(new Tuple3(uidColeccion, uidItem, 1));

    await UserDatabaseProvider().sumarItem(this.userModel, uidColeccion, uidItem, nuevo, valor);
  }

  //TODO restar item
  Future restarItemColeccion(String uidColeccion, String uidItem) async{

    bool eliminado = false;
    int valor = 0;

    for (int i = 0; i < this.userModel.items.length; i++){
      if (this.userModel.items[i].item1 == uidColeccion){
        if (this.userModel.items[i].item2 == uidItem) {
          this.userModel.items[i].item3 -= 1;
          valor = this.userModel.items[i].item3;
          if (this.userModel.items[i].item3 == 0) this.userModel.items.removeAt(i); eliminado = true;
        }
      }
    }

    await UserDatabaseProvider().restarItem(this.userModel, uidColeccion, uidItem, eliminado, valor);
  }

  Future<bool> existeUser(String nick) async{

    return await UserDatabaseProvider().existUserNick(nick);

  }

  Future otherUser(String uidUser) async{
    UserModel otherUserModel = await getUser(uidUser);
    _otherUserController.sink.add(otherUserModel);
  }

  Future<UserModel> getUser(String seguidor) async{

    return await UserDatabaseProvider().getUser(seguidor);

  }

}