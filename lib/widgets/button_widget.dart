import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Icon icon;
  final Color color;
  ButtonWidget({@required this.label,@required  this.onPressed,this.icon,this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        style: TextStyle(fontSize: 16.0),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity,46),
        primary: color,
      ),
      
    );
  }
}