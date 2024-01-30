// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextfield extends StatefulWidget
{
  CustomTextfield({this.padding = EdgeInsets.zero, this.hintText = "...", this.min= 0, this.max= 60, this.valueSet});

  void Function(bool valid, String textEntree)? valueSet;
  EdgeInsets padding;
  String hintText ;
  var min;
  var max;
  
  //Text
  
  
  
  @override
  State<StatefulWidget> createState() {
    return _CustomTextFieldState();
    
  }

}

class _CustomTextFieldState extends State<CustomTextfield> 
{ 
  String? errormessage;

   void function(String text_entree)
  {
    setState(() {
      errormessage = null;
    });
    
    var value = num.tryParse(text_entree) ;
    if(widget.min >= value)
    {
      setState(() {
        errormessage = "Le nombre saisi doit etre superieur à ${widget.min}";
      });
    }
    if(widget.max < value)
    {
      setState(() {
        errormessage = "Le nombre saisi doit etre inferieur à ${widget.max}";
      });
    }
    if(widget.valueSet != null)
    {widget.valueSet!((errormessage == null), text_entree);}
    
  }
  
  @override
  Widget build(BuildContext context) 
  {
   
     return Padding(
            padding: widget.padding ,
            child:      
            TextField(
            decoration: new InputDecoration(hintText: widget.hintText, errorText: errormessage),
            keyboardType: TextInputType.number,
            onSubmitted: function,
          ),);
            
    
  }
 
}
