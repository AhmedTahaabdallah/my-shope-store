import 'package:flutter/material.dart';
class TitleDefailt extends StatelessWidget{
  final String title;
  TitleDefailt(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: "oswald"),
    );
  }
}