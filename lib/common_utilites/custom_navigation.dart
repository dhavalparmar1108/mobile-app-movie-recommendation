import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNavigation
{
  static push(BuildContext context, Widget widget)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

}