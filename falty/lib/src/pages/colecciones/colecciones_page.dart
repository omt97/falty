import 'package:falty/src/bloc/coleccion_bloc.dart';
import 'package:falty/src/models/coleccion_model.dart';
import 'package:falty/src/widgets/buttons.dart';
import 'package:falty/src/widgets/carta_coleccion.dart';
import 'package:flutter/material.dart';

class ColeccionesPage extends StatelessWidget {

  static final routeName = 'colecciones';
  final label;
  final streamLista;

  final ColeccionBloc _coleccionBloc = ColeccionBloc();

  ColeccionesPage(this.label, this.streamLista);

  @override
  Widget build(BuildContext context) {

    double widthScreen = MediaQuery.of(context).size.width;

    _coleccionBloc.obtenerColecciones();

    //scaffold 
    return Scaffold(
      appBar: _appBar(),
      body: _body(widthScreen)
    );
  }

  //appbar con boton de marcha atras, filtro y titulo
  Widget _appBar(){

    return AppBar(
        title: Center(child: Text(label, style: TextStyle(fontSize: 16), textAlign: TextAlign.right,)),
        leading: Builder(
          builder: (context) {
            return back_arrow(context);
          }
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list), 
            onPressed: () {
              return;
            }
          )
        ],
      );
  }

  //body de la vista, es una lista 3*x donde x depende del numero de colecciones que se enseñen
  Widget _body(double widthScreen){
    return StreamBuilder(
        stream: streamLista,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){

          if (snapshot.hasData){

            List<Coleccion> colecciones = snapshot.data;

            int rowsCount = _getNumberOfRows(colecciones.length);
            int suma = 3;

            return Container(
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: rowsCount,
                itemBuilder: (BuildContext context, int index) {
                  if (index == rowsCount - 1){
                    suma = colecciones.sublist(index*3, colecciones.length).length;
                  }
                  List<Coleccion> subColecciones = colecciones.sublist(index*3, index*3 + suma);
                  return Row(
                    children: _obtenerItems(subColecciones, widthScreen-30, context)
                  );
                },
              ),
            );
          }
          else return Container();
        }
      );
  }

  //obtener el numero de filas, dependiendo del numero de colecciones
  int _getNumberOfRows(int length) {

    if (length%(3) == 0) return ((length/3).round());
    else return ((length/3).round() + 1);

  }

  //crear una vista para cada coleccion que enseñamos, con la foto y boton para acceder a la coleccion
  List<Widget> _obtenerItems(List<Coleccion> subColecciones, double width, BuildContext context) {

    List<Widget> row = [];

    for (int i = 0; i < subColecciones.length; ++i){
      row.add(cartaGrande(width, subColecciones[i], context));
      if (i < subColecciones.length - 1) row.add(SizedBox(width: 5,));
    }

    return row;

  }


}