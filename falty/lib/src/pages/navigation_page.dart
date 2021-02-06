import 'package:falty/src/bloc/user_bloc.dart';
import 'package:falty/src/pages/navigation/profile/usuario_page.dart';
import 'package:flutter/material.dart';

import 'navigation/home/home_page.dart';

class NavigationPage extends StatefulWidget {

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final UserBloc _userBloc = UserBloc();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: _callPage()
    );
  }

  Widget _callPage(){

    switch(currentPage){

      case 0: return HomePage();
      case 1: return HomePage();
      case 2: return HomePage();
      case 3:{
        return UsuarioPage(null);
      }

      default: return HomePage();

    }

  }

  Widget _bottomNavigationBar() {

    return BottomNavigationBar(
      selectedItemColor: Colors.greenAccent,
      unselectedItemColor: Colors.green,
      currentIndex: currentPage,
      onTap: (index){
        setState(() {
          currentPage = index;
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_back),
          label: 'Intercambios'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle),
          label: 'Profile'
        ),
      ],
    );

  }
}