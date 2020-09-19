import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;

  CustomButton(
      {this.text, this.onPressed, this.color = const Color(0xff1184ED)});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      onPressed: (onPressed != null) ? onPressed : () {},
      color: color,
    );
  }
}
