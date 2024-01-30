//theme de lappli

// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
class Themes
{
  final ThemeData theme1 = ThemeData
  (
    // ignore: prefer_const_constructors
    primarySwatch: Colors.deepOrange,
    fontFamily: "Quicksand",//police d'ecriture
    inputDecorationTheme: InputDecorationTheme
    (
      border: OutlineInputBorder(borderRadius: BorderRadius.all(
        Radius.circular(10))),
        
        ),
    // ignore: duplicate_ignore
    elevatedButtonTheme: ElevatedButtonThemeData(
      // ignore: prefer_const_constructors
      style: ElevatedButton.styleFrom(primary: Color(0xFFf9ac67)),//voir htmlcolorcode 0xFF--> Hexa
      ),
  );
}