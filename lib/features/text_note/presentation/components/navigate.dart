import 'package:flutter/material.dart';

void navigateTo(context,Widget widget)
{
  Navigator.push(context,MaterialPageRoute(builder:
      (BuildContext context)=>widget),);
}