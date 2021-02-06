class Coleccion {

  String uid;
  String titulo;
  String descripcion;
  String foto;
  String fecha;
  String empresa;
  int total;
  int numseguidores;
  int numitems;
  //uid usuarios
  List<String> seguidores;
  //uid items
  List<String> items;


  Coleccion({
    this.uid,
    this.titulo,
    this.descripcion,
    this.foto,
    this.fecha,
    this.empresa,
    this.total,
    this.numseguidores,
    this.numitems,
    this.seguidores,
    this.items,
  });

}