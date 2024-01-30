
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'; 
import 'page1.dart';
import 'page2.dart';
import 'delayed_animation.dart';
bool BTcon = false ;
String message="";
void bouton_BT(BuildContext context) async
{
  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => page1())); 
  if(result == true){
    BTcon = true ;
  ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text("Connecté")));
  
  }
  if(result == false){
    BTcon = false ;
    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text("Non-Connecté")));
  }
}

void bouton_reveil(BuildContext context) async
{
  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => page2())); 
  if(result == true){
  ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text("Message envoyé")));
  
  }
  if(result == false){
    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text("Ah...")));
  }
}

class MainPage extends StatefulWidget {
  final String title;
  final BluetoothDevice? server;
  const MainPage({this.title = "essai",this.server});
  


  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool value = false; 
  bool value1 = false;
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
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text(widget.title),),
        backgroundColor: Color(0xFFEDECF2),
        body: Center(
          child : 
            Padding(padding: EdgeInsets.all(25),child:construire() ),//Met de l'espace        
      ),
      );
 
  Widget construire()
  {
    return Column(
          children: [
            DelayedAnimation(
                delay: 1500,
                child: Container(
              child: Container ( //color: Color.fromARGB(255, 252, 252, 252) ,
              //child: Text("Bienvenue",style: TextStyle(fontSize: 45),)))),
              child: Column(
                  children: [
                    Text(
                      "Bienvenue",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Dans le module de réveil connecté via Bluetooth",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )))),
              Spacer(),
              Padding(padding: EdgeInsets.symmetric(vertical: 10) ,child:
              DelayedAnimation(
                  delay: 2500,
                  child: Container(
              child:
                Image.asset(
                  value ? 'asset/on.png' : 'asset/off.png',
                  height: 300,
                )))),
              Spacer(),
              DelayedAnimation(
                delay: 3500,
                child: Container(
                child:
              Row(
                children: 
                [
                  
                  Expanded(child: ElevatedButton(onPressed: (() => bouton_reveil(context)), child: Text("Réveil"))),
                    
                  Expanded(child: ElevatedButton(onPressed: (() => bouton_BT(context)), child: const Text("Bluetooth")))
                
                ,
                ]))
              ),
              DelayedAnimation(
                delay: 4500,
                child: Container(
                child:
                 Expanded(child :buildHeader( text: 'Turn OFF/ON', child: buildSwitch(),
                  ),))),

               Padding(padding: EdgeInsets.symmetric(vertical: 10) ,child:
                DelayedAnimation(
                delay: 5500,
                child: Container(
                child:
                 ElevatedButton(onPressed: (() => exit(0)), child: Text("Quitter"))))),
          ],
        );
  }

    Widget buildHeader({
     required Widget child ,
     required  String text }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
                children: 
                [
                  Expanded(child :Text(text,style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),), ),
                  
                  const SizedBox(height: 1),  child,
                ]
              ),
         
        ],
      );

  Widget buildSwitch() => Transform.scale(
        scale: 2,
        child: Switch.adaptive(
          //thumbColor: MaterialStateProperty.all(Colors.red),
          //trackColor: MaterialStateProperty.all(Colors.orange),

          activeColor: Colors.blueAccent,
          activeTrackColor: Colors.blue.withOpacity(0.4),
          inactiveThumbColor: Colors.orange,
          inactiveTrackColor: Colors.black87,
          splashRadius: 50,
          value: value,
          onChanged: (value) => setState(() {this.value = value; if(value1 == true){message="1";}else{message="0";} _sendMessage(message);message="";} ),
        ),
      );
}
      
   
  // mettre des elements sur la meme ligne
  /*Row(
      Children: 
      [ 
        Expanded(child : widget 1
        Spacer(),//met un grand espace
        Widget 2
        
      ],
      
 )
 Expanded(child : Divider(thickness: 1.5,))//Met une ligne pour separer
 mainAxisAlignment: MainAxisAlignment.center//Centre la page

class bluetooth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => bluetooth())) ; 
      return Text("");
  }
}*/