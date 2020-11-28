import 'package:falty/src/bloc/user_bloc.dart';
import 'package:falty/src/models/user_model.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatelessWidget {

  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userBloc.userModel.email),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(_userBloc.userModel.photo),
            Text('Name: ' + _userBloc.userModel.name),
            Text('Nick: ' + _userBloc.userModel.nick),
            Text('Id: ' + _userBloc.userModel.uid),
            RaisedButton(
              child: Text('Logout'),
              onPressed: (){
                _userBloc.logout();
              },
            )
        ],),
      ),
    );
  }

}