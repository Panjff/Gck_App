
import 'package:flutter/material.dart'; 
import 'package:flutter/cupertino.dart'; //widget with ios design
import 'mainpage.dart';
import 'theme.dart';//Appporte des couleurs

void main() {
  runApp(essai());
}

class essai extends StatelessWidget {
  static final String title = 'Accueil';

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: Themes().theme1,//Defini la couleur de l'application        
        home: MainPage(title: title),
        
      );
}



