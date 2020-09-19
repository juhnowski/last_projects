import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:rsv_mobile/utils/adaptive.dart';

class Heading extends StatelessWidget {
  final String _title;
  final bool arrow;
  final Widget screen;
  final GestureTapCallback onTap;
  final Color color;

  Heading(
    this._title, {
    this.arrow = true,
    this.screen,
    this.onTap,
    this.color = const Color(0xffF38095),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: Margin.all(context, def: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: new Text(_title,
                  style: new TextStyle(
                      fontSize: FontSize.h1(),
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
            ),
            arrow ? Icon(Icons.arrow_forward_ios) : Container()
          ],
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (screen != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        }
      },
    );
  }
}

class Label extends StatelessWidget {
  final String _text;
  Label(this._text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: Margin.margin(context, def: 20)),
      child: Text(_text,
          style: TextStyle(
              fontSize: FontSize.body(),
              color: Color(0xff979797),
              fontWeight: FontWeight.w700)),
    );
  }
}
