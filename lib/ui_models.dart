import 'package:flutter/cupertino.dart';

class AppBarModel{
  String title;
  List<Widget> actions;
  Widget? leading;

  AppBarModel({this.leading,required this.title,required this.actions});

}