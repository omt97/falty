import 'package:falty/src/bloc/coleccion_bloc.dart';
import 'package:falty/src/bloc/user_bloc.dart';
import 'package:falty/src/models/user_model.dart';
import 'package:falty/src/widgets/lista_colecciones.dart';
import 'package:flutter/material.dart';

class UsuarioPage extends StatefulWidget {

  final uid;

  UsuarioPage(this.uid);

  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final UserBloc _userBloc = UserBloc();

  final ColeccionBloc _coleccionBloc = ColeccionBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double heightList = heightScreen/3.75;

    if (widget.uid != null) _userBloc.otherUser(widget.uid);

    return Scaffold(
      body: StreamBuilder<UserModel>(
        stream: widget.uid == null ? _userBloc.userStream : _userBloc.otherUserStream,
        builder: (context, snapshot) {

          if(snapshot.hasData){

            UserModel userModel = snapshot.data;
            _coleccionBloc.obtenerColeccionesSeguidas(userModel.uid);

            return SingleChildScrollView(
              child: Column(
                children: [
                  //crea un container con fotos y mas info user
                  _infoUsuario(widthScreen, userModel),
                  //llamo a un widget que crea una lista scrollable horizontalmente con las colecciones
                  list(heightList, widthScreen, "Colecciones seguidas", context, _coleccionBloc.coleccionesSeguidasStream),
                  widget.uid == null ? RaisedButton(
                    child: Text('Logout'),
                    onPressed: (){
                      _userBloc.logout();
                    },
                  ) : Container()
                ],
              ),
            );
          }else {
            _userBloc.recargarUser();
            return Container();
          }
        }
      )
    );
  }

//informacion del usuario, seguidores, colecciones, seguidos
  Widget _infoUsuario(double widthScreen, UserModel userModel) {
    return Container(
      width: widthScreen,
      height: 400,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            children: <Widget>[
              _fondoUser(),
              _infoUser(userModel.colecciones.length, userModel.seguidores != null ? userModel.seguidores.length : 0, userModel.seguidos != null ? userModel.seguidos.length : 0),              
            ],
          ),
          _fotoUsuario(), //foto usuario
          widget.uid == null ? _botonElevado(Icon(Icons.notification_important), 40, null, 20, null) : Container(), //boton notificaciones TODO color si hay notis o no, habra que poner alguna variable mas un color con if
          widget.uid == null 
            ? _botonElevado(Icon(Icons.settings), 40, null, null, 20)
            : Positioned(
              top: 40,
              left:20,
                child: IconButton(
                icon: Icon(Icons.arrow_downward, color: Colors.white,),
                onPressed: () => Navigator.pop(context),
              ),
            ), //boton ajustes
        ],
      ),
    );
  }

  //imagen de fondo del usuario perfil
  Widget _fondoUser() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.red,
      child: Image.asset('assets/gorm.jpg', fit: BoxFit.cover),
    );
  }

  //informacion del usuario, seguidores, seguidos, colecciones
  Widget _infoUser(int colecciones, int seguidores, int seguidos) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      width: double.infinity,
      height: 200,
      color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_userBloc.userModel.nick, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),),
          Expanded(child: SizedBox(height: double.infinity,)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: SizedBox(width: double.infinity,)),
              _valorTexto('seguidores', seguidores),
              Expanded(child: SizedBox(width: double.infinity,)),
              _valorTexto('colecciones', colecciones),
              Expanded(child: SizedBox(width: double.infinity,)),
              _valorTexto('seguidos', seguidos),
              Expanded(child: SizedBox(width: double.infinity,)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _valorTexto(String s, int i) {
    return Text(
      i.toString() + '\n' + s,
      textAlign: TextAlign.center,
    );
  }

  Widget _fotoUsuario() {
    return Container(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(200.0),
          child: Image.network(_userBloc.userModel.photo)
        ),
    );
  }

  Widget _botonElevado(Icon icon, double top, double bottom, double right, double left) {

    return Positioned(
      top: top,
      bottom: bottom,
      right: right,
      left: left,
      child: Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.red
        ),
        child: IconButton(
          onPressed: (){return;}, 
          icon: icon,
          padding: EdgeInsets.all(0),
        ),
      ),
    );

  }
}