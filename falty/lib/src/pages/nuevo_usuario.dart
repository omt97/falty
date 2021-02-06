import 'package:falty/src/bloc/user_bloc.dart';
import 'package:falty/src/models/user_model.dart';
import 'package:falty/src/util/idiomas.dart';
import 'package:flutter/material.dart';

class NuevoUsuario extends StatefulWidget {

  @override
  _NuevoUsuarioState createState() => _NuevoUsuarioState();
}

class _NuevoUsuarioState extends State<NuevoUsuario> {
  final formKey = GlobalKey<FormState>();

  final UserBloc _userBloc = UserBloc();
  UserModel finalUserModel;

  @override
  Widget build(BuildContext context) {

    finalUserModel = _userBloc.userModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(Idiomas.informacionUsario('cat'))
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _nuevaFoto(),
                _crearNombre(),
                _crearApellido(),
                _crearNick(),
                //TODO _escogerColor(),
                _crearBoton()
              ],
            ),

          )
        )
      )
    );
  }

  _nuevaFoto() {

    return Container(
      color: Colors.red,
      width: 200,
      height: 200,
      child: RaisedButton(
        child:
          finalUserModel.photo != null ?
          ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: Image.network(
              finalUserModel.photo,
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
          ) :
          ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: Image.asset(
              'assets/falty_logo.png',
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
          ),
          onPressed: () { print('Modificar foto'); },
      )
    );

  }

  _crearNombre() {

    return Row(
      children: [
        Expanded(child: SizedBox(width: double.infinity,)),
        Icon(Icons.title, /*color: getAppColor(userBloc.color, 500)*/),
        Expanded(child: SizedBox(width: 5,)),
        Container(
          width: 200,
          child: TextFormField(
            //expands: true,
            initialValue: (finalUserModel.name == null) ? '': finalUserModel.name,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Nombre Usuario'
            ),
            onSaved: (title) => finalUserModel.name = title ,
            validator: (title){
              if(title.length > 0){
                return null;
              } else {
                return 'Introducir nombre';
              }
            }
          ),
        ),
        Expanded(child: SizedBox(width: double.infinity,)),
      ],
    );

  }

    _crearApellido() {

    return Row(
      children: [
        Expanded(child: SizedBox(width: double.infinity,)),
        Icon(Icons.title, /*color: getAppColor(userBloc.color, 500)*/),
        Expanded(child: SizedBox(width: 5,)),
        Container(
          width: 200,
          child: TextFormField(
            //expands: true,
            initialValue: (finalUserModel.surname == null) ? '': finalUserModel.surname,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Apellido Usuario'
            ),
            onSaved: (title) => finalUserModel.surname = title ,
            validator: (title){
              if(title.length > 0){
                return null;
              } else {
                return 'Introducir apellido';
              }
            }
          ),
        ),
        Expanded(child: SizedBox(width: double.infinity,)),
      ],
    );

  }

  _crearNick() {

    return Row(
      children: [
        Expanded(child: SizedBox(width: double.infinity,)),
        Icon(Icons.title, /*color: getAppColor(userBloc.color, 500)*/),
        Expanded(child: SizedBox(width: 5,)),
        Container(
          width: 200,
          child: TextFormField(
            //expands: true,
            initialValue: (finalUserModel.nick == null) ? '': finalUserModel.nick,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Nick Usuario'
            ),
            onChanged: (title) => finalUserModel.nick = title ,
            validator: (title){
              if(title.length > 0){
                return null;
              } else {
                return 'Introducir nick';
              }
            }
          ),
        ),
        Expanded(child: SizedBox(width: double.infinity,)),
      ],
    );
  }

  _crearBoton() {

    return RaisedButton.icon(
      icon: Icon(Icons.save), 
      label: Text('Crear'),
      onPressed: () async{

        print(finalUserModel.nick);

        if (!formKey.currentState.validate()) return;
        if (await _userBloc.existeUser(finalUserModel.nick)) {
          print('existe usuario');
          return;
        }
        formKey.currentState.save();

        _userBloc.crearUsuario(finalUserModel);

      }, 
    );
  }

}