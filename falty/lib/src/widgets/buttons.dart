import 'package:flutter/material.dart';

Widget back_arrow(BuildContext context){
  return IconButton(
    color: Colors.white,
    icon: Icon(Icons.arrow_downward),
    onPressed: () => Navigator.pop(context),
  );
}