class Coleccion {

  String uid;
  String descripcion;
  String foto;
  String fecha;
  String empresa;
  int total;
  //uid usuarios
  List<String> seguidores;
  //uid items
  List<String> items;


  Coleccion({
    this.uid,
    this.descripcion,
    this.foto,
    this.fecha,
    this.empresa,
    this.total,
    this.seguidores,
    this.items,
  });

}