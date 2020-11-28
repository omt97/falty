import 'package:falty/src/bloc/user_bloc.dart';
import 'package:falty/src/util/decoracion.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    print('caca');
    return  Scaffold(
      backgroundColor: Colors.deepPurple[400],
      /*appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 0,
        title: Text('Sign in to Colecty')
      ),*/
      body: Stack(
        children: [
          Positioned(
            top: 150,
            right: 70,
            child: circulo
          ),
          Positioned(
            top: 300,
            right: -40,
            child: circulo
          ),
          Positioned(
            top: -5,
            left: 20,
            child: circulo
          ),
          Positioned(
            bottom: 60,
            right: 20,
            child: circulo
          ),
          Positioned(
            bottom: 250,
            left: 20,
            child: circulo
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: circulito
          ),
          Positioned(
            bottom: -10,
            left: 120,
            child: circulito
          ),
          Positioned(
            bottom: 150,
            left: 100,
            child: circulito
          ),
          Positioned(
            top: 250,
            left: 20,
            child: circulito
          ),
            
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
            child: Form(
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 150),
                    Image(image: AssetImage('assets/falty_logo.png'), width: 150,),
                    SizedBox(height: 125),
                    Container(
                      height: 45,
                      width: 185, 
                      child: RaisedButton(
                        color: Colors.white,
                        elevation: 0,
                        focusElevation: 0,
                        disabledElevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        shape: StadiumBorder(),
                        child: Row( 
                          children: <Widget>[
                            Image(image: AssetImage('assets/logoGoogle.png'), width: 20,),
                            Expanded(child: SizedBox(width: double.infinity,)),
                            Text('Sign in with Google')
                          ]
                        ),
                        onPressed: ()async{
                          /*setState(() {
                            loading = true;
                          });*/
                          await _userBloc.loginWithGoogle();
                          /*setState(() {
                            loading = false;
                          });*/
                        }
                      ),
                    )
                  ]
                ),
              )
            )
          ),

          
        ],
      ),
    );
  }
}