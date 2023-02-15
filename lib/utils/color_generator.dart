import 'dart:ui';
import 'package:flutter/material.dart';

class ColorGenerator{

  static Color? colorGenerator(int number)
  {
    Color? color;
    int lastNumber= number%10;

    if(lastNumber.isEven)
    {
      if(lastNumber==0||lastNumber==4||lastNumber==8)
      {
        color=Colors.cyan.shade100.withOpacity(0.3);
      }
      else
      {
        color=Colors.lightGreen.shade100.withOpacity(0.5);
      }

    }
    else
    {
      if(lastNumber==1||lastNumber==5||lastNumber==9)
      {
        color=Colors.amberAccent.shade100.withOpacity(0.5);
      }
      else if(lastNumber==3||lastNumber==7)
      {
        color=Colors.pinkAccent[100]?.withOpacity(0.5);
      }
    }

    return color;
  }
}