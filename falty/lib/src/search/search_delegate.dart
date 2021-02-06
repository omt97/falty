import 'dart:io';

import 'package:falty/src/bloc/coleccion_bloc.dart';
import 'package:falty/src/bloc/user_bloc.dart';
import 'package:falty/src/models/coleccion_model.dart';
import 'package:falty/src/pages/colecciones/coleccion_page.dart';
import 'package:falty/src/util/animations.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate{

  final coleccionBloc = new ColeccionBloc();

  String seleccion = '';
  final coleccio = new Coleccion();
  final userBloc = new UserBloc();


  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      //primaryColor: getAppColor(userBloc.color, 400),
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      primaryColorBrightness: Brightness.light,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear), 
          onPressed: (){
            query = '';

          }
        ),

      ];
    }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ), 
      onPressed: (){
        close(context, null);
      }
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {

    coleccionBloc.obtenerColeccionesSearch(query);

     return StreamBuilder(
      stream: coleccionBloc.coleccionesSearchStream,
      builder: (BuildContext context, AsyncSnapshot<List<Coleccion>> snapshot){


        if (snapshot.hasData){

          print(snapshot.data);
          
          List<Coleccion> colecciones = snapshot.data;

          return ListView.builder(
            
            itemCount: colecciones.length,
            itemBuilder: (BuildContext context, int i) {
              return InkWell(
                onTap: (){
                  coleccionBloc.obtenerColeccion(colecciones[i].uid);
                  Navigator.of(context).push(createRoute(ColeccionPage(colecciones[i])));
                  //close(context, null);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    //color: getAppColor(userBloc.color, 50)
                  ),
                  child: ListTile(
                    leading: _imagenColeccion(colecciones[i].titulo, colecciones[i].foto),
                    title: Text(colecciones[i].titulo),
                    //subtitle: ,
                  ),
                ),
              );
            },
          );

        } else {
          return Container();
        }
      },
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {

    print('------------- '+ query);

    coleccionBloc.obtenerColeccionesSearch(query);


    return StreamBuilder(
      stream: coleccionBloc.coleccionesSearchStream,
      builder: (BuildContext context, AsyncSnapshot<List<Coleccion>> snapshot){


        if (snapshot.hasData){

          print(snapshot.data);
          
          List<Coleccion> colecciones = snapshot.data;

          return ListView.builder(
            
            itemCount: colecciones.length,
            itemBuilder: (BuildContext context, int i) {
              return InkWell(
                onTap: (){
                  coleccionBloc.obtenerColeccion(colecciones[i].uid);
                  Navigator.of(context).push(createRoute(ColeccionPage(colecciones[i])));
                  //close(context, null);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    //color: getAppColor(userBloc.color, 50)
                  ),
                  child: ListTile(
                    leading: _imagenColeccion(colecciones[i].titulo, colecciones[i].foto),
                    title: Text(colecciones[i].titulo),
                    //subtitle: ,
                  ),
                ),
              );
            },
          );

        } else {
          return Container();
        }
      },
    );
  }

  Widget _imagenColeccion(String title, String photo){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0)
      ),
      height: 50.0,
      width: 50.0,
      
      child: Hero(
        tag: title,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0), 
          child: /*photo != null ? Image.network(
            photo,
            fit: BoxFit.cover,
          ):*/ Image.asset(
            photo,
            fit: BoxFit.cover,
          )
        ),
      ),
    );
  }




}