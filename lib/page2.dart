

import 'dart:typed_data';
import 'delayed_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'customTextfield.dart';
String message = "";
bool like_h =false;
bool like_m =false;
bool like_c =false;
void envoie(valid , text_entree)
{
  message=message + text_entree ;
}
class page2 extends StatefulWidget {
  final BluetoothDevice? server;

  const page2({this.server});
  @override
  State<StatefulWidget> createState() {
    return _page2State();
  }
}
class _page2State extends State<page2> {
  BluetoothConnection? connection ;
  bool isConnecting = true;
  bool like =false ; 
  bool get isConnected => connection != null && connection!.isConnected;
  bool isDisconnecting = false;
  
  @override
  void initState() {
    super.initState();
    _getBTConnection() ;
  }

   @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      if(connection != null)
      {
        connection!.dispose();
      }
      
      connection = null;
    }
    super.dispose();
  }

 _getBTConnection() {
  if(widget.server!= null)
  {
     BluetoothConnection.toAddress(widget.server!.address).then((_connection) {
      connection = _connection;
      isConnecting = false;
      isDisconnecting = false;
      setState(() {});
    });
  }
  }

void _sendMessage(String value1) async {
    value1 = value1.trim();
    if (value1.length > 0) {
      try {
        List<int> list = value1.codeUnits;
        Uint8List bytes = Uint8List.fromList(list);
        if(connection != null)
        {
          connection!.output.add(bytes);
          await connection!.output.allSent;
        }
        
      } catch (e) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context, like );
        },) ,
        title: Text("Connection")),
        backgroundColor: Color(0xFFEDECF2),
        body: Column(
          children: 
          [
            //CustomTextfield(padding: EdgeInsets.all(25),hintText: "Saisir le jour (Lundi=1 , Mardi= 2 , ... )", max: 7 ),
             DelayedAnimation(
                delay: 1500,
                child: Container(
                child:
            CustomTextfield(padding: EdgeInsets.all(25),hintText: "Saisir l'heure de réveil", max: 23 , 
            valueSet: (valid,text_entree ){if(valid == true)
            {
              like =false ;
              message= "#" + text_entree +";";
              setState(() {like_c =valid ;}); 
              }
              else
            {
               setState(() {like_c =valid ;});
            }},))),

             DelayedAnimation(
                delay: 2500,
                child: Container(
                child:
            CustomTextfield(padding: EdgeInsets.all(25),hintText: "Saisir les minutes de réveil", max: 59, 
            valueSet: (valid,text_entree ){
            if(valid == true)
            {
              message=message + text_entree + ";" ;
              setState(() {like_h =valid ;});
            }
            else
            {
               setState(() {like_h =valid ;});
            }},))),

             DelayedAnimation(
                delay: 3500,
                child: Container(
                child:
            CustomTextfield(padding: EdgeInsets.all(25),hintText: "Saisir le temps de réveil", min: 1 , 
            valueSet: (valid,text_entree ){if(valid == true)
            {
              message=message + text_entree ;
               
              setState(() {like_m =valid ;});
            }
            else
            {
               setState(() {like_m =valid ;});
            }},))),

             DelayedAnimation(
                delay: 4500,
                child: Container(
                child:
            Padding(padding: EdgeInsets.symmetric(vertical: 10) ,child:

            ElevatedButton(onPressed: ((like_c && like_h && like_m) ? () 
            {
              _sendMessage(message);
              message="";
              
              setState(() {
              like_c= false;
              like_h= false;
              like_m= false;
              like= true;});
              Navigator.pop(context, like );
              
              
              } : null)  , child: Text("Validez"))))),
          ] 
          
      ),
);
}
}

