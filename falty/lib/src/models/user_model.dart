class UserModel{

  final String uid;
  final String nick;
  final String email;
  final String name;
  final String surname;
  String color;
  String photo;
  //uid usuarios
  final List<String> seguidos;
  //uid usuarios
  final List<String> seguidores;
  //uid usuarios
  final List<String> bloqueados;
  //uid logro
  final List<String> logros;
  //uid coleccion
  final List<String> colecciones;

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
    this.colecciones 
  });

}