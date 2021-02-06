import 'package:falty/src/models/coleccion_model.dart';
import 'package:falty/src/pages/colecciones/colecciones_page.dart';
import 'package:falty/src/util/animations.dart';
import 'package:falty/src/widgets/carta_coleccion.dart';
import 'package:flutter/material.dart';

Widget list(double height, double widthScreen, String label, BuildContext context, Stream<List<Coleccion>> lista){

    return StreamBuilder(
      stream: lista,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
        if (snapshot.hasData){

          List<Coleccion> colecciones = snapshot.data;

          return Container(
            height: height,
            width: widthScreen,
            color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _labelListaColeccion(label, context, lista),
                Container(
                  height: height-48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colecciones.length,
                    itemBuilder: (BuildContext context, int index) {
                      Coleccion coleccion = colecciones[index];
                      return carta(coleccion, context);
                    },
                  ),
                ),
              ],
            ),
          );
        }
        else {
          return Container();
        }
      },
    );
}

Widget _labelListaColeccion(String label, BuildContext context, Stream<List<Coleccion>> lista) {
  return Container(
    height: 20,
    child: Row(
      children: [
        Text(label),
        Expanded(child: SizedBox(width: double.infinity)),
        RaisedButton(
          onPressed: () {  
            Navigator.of(context).push(createRoute(ColeccionesPage(label, lista)));
            //Navigator.pushNamed(context, "colecciones");
          },
          child: Text('View All')
        ),
      ],
    ),
  );
}