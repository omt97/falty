import 'package:falty/src/models/user_model.dart';
import 'package:falty/src/pages/auth/sign_in.dart';
import 'package:falty/src/pages/navigation/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  static final String routeName = 'wrapper';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (user != null){
      return NavigationPage();
    }else {
      return SignIn();
    }
  }
}