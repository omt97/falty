import 'package:falty/src/util/tuples.dart';

class UserModel{

  String uid;
  String nick;
  String email;
  String name;
  String surname;
  String color;
  String photo;
  //uid usuarios
  List<String> seguidos;
  //uid usuarios
  List<String> seguidores;
  //uid usuarios
  List<String> bloqueados;
  //uid logro
  List<String> logros;
  //uid coleccion
  List<String> colecciones;
  //uid coleccion
  List<Tuple3<String, String, int>> items;

  UserModel({
    this.uid,
    this.nick,
    this.email,
    this.name,
    this.surname,
    this.color,
    this.photo,
    this.seguidos,
    this.seguidores,
    this.bloqueados,
    this.logros,
    this.colecciones, 
    this.items
  });

}