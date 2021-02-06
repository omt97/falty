import 'package:falty/src/bloc/coleccion_bloc.dart';
import 'package:falty/src/bloc/user_bloc.dart';
import 'package:falty/src/models/coleccion_model.dart';
import 'package:falty/src/models/user_model.dart';
import 'package:falty/src/pages/navigation/profile/usuario_page.dart';
import 'package:falty/src/util/animations.dart';
import 'package:flutter/material.dart';

class ColeccionPage extends StatefulWidget {
  
  
  final Coleccion coleccion;

  ColeccionPage(this.coleccion);

  @override
  _ColeccionPageState createState() => _ColeccionPageState();
}

class _ColeccionPageState extends State<ColeccionPage> {
  final _userBloc = new UserBloc();
  final _coleccionBloc = new ColeccionBloc();

  @override
  Widget build(BuildContext context) {

    double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder<Object>(
        stream: _coleccionBloc.coleccionStream,
        builder: (context, snapshot) {

          if(snapshot.hasData){

            Coleccion coleccion = snapshot.data;

            return CustomScrollView(
              slivers: <Widget>[
                _crearAppBar(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(height: 10.0),
                      _seguidores(widthScreen, coleccion.numseguidores),
                      Divider(thickness: 1,),
                      _descripcion(widthScreen),
                      Divider(thickness: 1),
                      _informacion(widthScreen),
                      Divider(thickness: 1),
                      _usuarios(widthScreen, coleccion.seguidores),
                      Divider(thickness: 1),
                      _graficoTenguis(widthScreen),
                    ]
                  ),
                )

              ],
            );
          }else{
            print(widget.coleccion.uid);
            _coleccionBloc.obtenerColeccion(widget.coleccion.uid);
            return Container();
          }
        }
      )
    );
  }

//appbar con la foto de la coleccion
  _crearAppBar() {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.greenAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar( //espacio adaptado para widget
        centerTitle: true,
        title: Text(
          widget.coleccion.titulo, 
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/falty_logo.png'), 
          image: AssetImage('assets/gorm.jpg'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
          
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(Icons.arrow_downward),
            onPressed: () => Navigator.pop(context),
          );
        }
      ),
    );
  }

//muestra cuanta gente sigue la coleccion
  Widget _seguidores(double witdh, int seguidores) {

    return Container(
      width: witdh,
      child: Row( 
        children: <Widget>[
          SizedBox(width: 20,),
          Icon(Icons.people),
          SizedBox(width: 20,),
          Text(seguidores.toString() + " seguidores"),
          Expanded(child: SizedBox(width: double.infinity,)),
          IconButton(
            iconSize: 20,
            splashRadius: 20,
            padding: EdgeInsets.all(0.0),
            color: _userBloc.sigoColeccion(widget.coleccion.uid) ? Colors.green : Colors.red,
            icon: Icon(Icons.check_box), 
            onPressed: (){
              _userBloc.sigoColeccion(widget.coleccion.uid) ? _userBloc.noSeguirColeccion(widget.coleccion.uid) : _userBloc.seguirColeccion(widget.coleccion.uid);
              _coleccionBloc.obtenerColeccion(widget.coleccion.uid);
            }
          ),
          SizedBox(width: 20,),
        ]
      ),
    );

  }

//muestra la descripcion de la coleccion
  Widget _descripcion(double witdh) {

    return Container(
      width: witdh,
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20,),
          Text('Descripción', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          Text(widget.coleccion.descripcion)
        ]
      ),
    );

  }

//muestra informacion sobre la coleccion
  _informacion(double witdh) {
    return Container(
      width: witdh,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _itemInfo(Icons.card_travel, widget.coleccion.numitems.toString()),
              _itemInfo(Icons.merge_type, 'cromos'),
            ],
          ),
                    Row(
            children: <Widget>[
              _itemInfo(Icons.timeline, widget.coleccion.fecha.toString()),
              _itemInfo(Icons.build, widget.coleccion.empresa),
            ],
          )
        ],
      ),
    );
  }

  //logo + info
  _itemInfo(IconData icon, String words) {
    return Row( 
      children: <Widget>[
        SizedBox(width: 20,),
        Icon(icon),
        SizedBox(width: 20,),
        Text(words)
      ]
    );
  }

//una lista de algunos usuarios que siguen la coleccion
  _usuarios(double witdh, List<String> seguidores) {

    List<UserModel> users = [];

    print('------------------------ ' + seguidores.toString());

    for (int i = 0; i < seguidores.length; ++i){
      //users.add(await _userBloc.getUser(seguidores[i])); 
    }

    return Container(
      width: witdh,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: seguidores.length,
        itemBuilder: (BuildContext context, int index) { 
          return _fotoUser(seguidores[index]);
        },
      ),
    );
  }

//la foto del usuario
  _fotoUser(String user){
    return FutureBuilder<Object>(
      future: _userBloc.getUser(user),
      builder: (context, snapshot) {

        if(snapshot.hasData){

          UserModel usermodel = snapshot.data;

          return Column(
            children: <Widget>[
              /*Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50)
                ),
                margin: EdgeInsets.all(15),
                width: 100,
                height: 100,
                //child: Text("hola"),
              ),*/
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(createRoute(UsuarioPage(usermodel.uid)));
                },
                child: Container(
                  /*decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(150)
                  ),
                  
                  width: 100,
                  height: 100,*/
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(15),
                  child: Hero(
                      tag: usermodel.uid,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75.0),
                        child: Image.network(usermodel.photo, fit: BoxFit.contain,)
                      ),
                  ),
                ),
              ),
              Text(usermodel.nick)
            ],
          );
        } else{
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

//un grafio que no funciona todavia
  _graficoTenguis(double width) {

    return Container(
      width: width,
      child: Image.asset(
        'assets/grafica.png'
      ),
    );

  }
}