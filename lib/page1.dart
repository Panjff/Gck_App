
// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:test1/page2.dart';
import 'dart:convert';
import 'BluetoothDeviceListEntry.dart';
import 'delayed_animation.dart';

class page1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _page1State();
  }
}

class _page1State extends State<page1> with WidgetsBindingObserver{
  bool ?like;
 BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  List<BluetoothDevice> devices = <BluetoothDevice>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getBTState();
    _stateChangeListener();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      //resume
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      }
    }
  }

  _getBTState() {
    FlutterBluetoothSerial.instance.state.then((state) {
      _bluetoothState = state;
      if (_bluetoothState.isEnabled)
      {
        _listBondedDevices();
      }
      setState(() {});
    });
  }

  _stateChangeListener() {
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      _bluetoothState = state;
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      } else {
        devices.clear();
      }
      print("State isEnabled: ${state.isEnabled}");
      setState(() {});
    });
  }

  _listBondedDevices() {
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      devices = bondedDevices;
      setState(() {});
    });
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
        title: Text("Connection du bluetooth")),
        backgroundColor: Color(0xFFEDECF2),
        body: Container(
          child: Column(children: [
             DelayedAnimation(
                delay: 1500,
                child: Container(
                child:
            SwitchListTile(
              title: Text("Allumage"),
              value: _bluetoothState.isEnabled, onChanged: (bool value){
                future() async{
                  if(value)
                  {
                    await FlutterBluetoothSerial.instance.requestEnable();
                  }
                  else
                  {
                    await FlutterBluetoothSerial.instance.requestDisable();
                  }
                  future().then((_)
                  {
                     setState(() {});
                  });
                }
              }

              ))),

           DelayedAnimation(
                delay: 2500,
                child: Container(
                child:
          ListTile(
            title: Text("Connection"),
            trailing: RaisedButton(
              child: Text("Setting"),onPressed: (){
                FlutterBluetoothSerial.instance.openSettings();
              }),
          ))),
          Expanded(
              child: ListView(
                children: devices.map((_device) => BluetoothDeviceListEntry
                (
                  device : _device,
                  enabled : true,
                  onTap: (){
                    like = true ;
                    setState(() {});
                    Navigator.push(context, MaterialPageRoute(builder: (context) => page2())); 
                  }
                )).toList(),
              ),
            )
          ],
          ),
        )
)
;
}
}