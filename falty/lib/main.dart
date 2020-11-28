import 'package:falty/src/bloc/user_bloc.dart';
import 'package:falty/src/models/user_model.dart';
import 'package:falty/src/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());

final UserBloc _userBloc = UserBloc();
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: _userBloc.userStream,
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'wrapper',
        routes: {
          Wrapper.routeName: (BuildContext context) => Wrapper(),
        }
      )
    );
  }
}