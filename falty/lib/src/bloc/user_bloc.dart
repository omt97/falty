import 'dart:async';

import 'package:falty/src/models/user_model.dart';
import 'package:falty/src/provider/auth.dart';
import 'package:falty/src/provider/database/user_database.dart';

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

  //obtener stream con info del bloque
  Stream<UserModel> get userStream => _userController.stream;

  dispose(){
    _userController?.close();
  }

  //iniciar session con google
  Future<dynamic> loginWithGoogle() async{
    UserModel user = await authProvider.loginGoogle();

    bool existe = await DatabaseProvider().existUser(user.uid);

    if (!existe) await DatabaseProvider().createUser(user);

    //user.color = await DatabaseProvider(uid: user.uid).obtenerColor();
    print(user.name + ' ' + user.email);
    print('pedo');

    _userController.sink.add(user);
    print('CACA2');
    if (user != null){
      this.userModel = user;
    }

    

    return user;
  }

  //logout
  Future logout() async {
    await authProvider.googleSignout();
    _userController.sink.add(null);
  }

}