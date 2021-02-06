import 'package:falty/src/models/coleccion_model.dart';
import 'package:falty/src/pages/colecciones/coleccion_page.dart';
import 'package:falty/src/util/animations.dart';
import 'package:flutter/material.dart';

Widget carta(Coleccion coleccion, BuildContext context){
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.all(5),
      width: 110,
      color: Colors.green,
      child: ClipRRect(
        //borderRadius: BorderRadius.circular(15.0), 
        child: _getImagen(coleccion.foto),
      ),
    ),
    onTap: (){
      Navigator.of(context).push(createRoute(ColeccionPage(coleccion)));
    },
  );
}

Widget cartaGrande(double width, Coleccion coleccion, BuildContext context){
  return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        width: width/3,
        height: (width/3)*1.5,
        color: Colors.green,
        child: ClipRRect(
          //borderRadius: BorderRadius.circular(15.0), 
          child: _getImagen(coleccion.foto),
        ),
      ),
      onTap: (){
        Navigator.of(context).push(createRoute(ColeccionPage(coleccion)));
      },
    );
}

Image _getImagen(String photo) {
  try{
    //return Image.file(File(photo), fit: BoxFit.cover);
    return Image.asset(photo, fit: BoxFit.cover);
  } catch (e) {
    return Image.asset('assets/logo.png', fit: BoxFit.cover);
  }
}