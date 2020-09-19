import 'package:flutter/material.dart';

class LabeledIcon extends StatelessWidget {
  final IconData _icon;
  final String _label;

  LabeledIcon(this._icon, this._label);
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Icon(_icon, size: 42, color: Color(0xff1184ED)),
          new Text(
            _label,
            style: TextStyle(color: Color(0xff1184ED)),
            overflow: TextOverflow.visible,
            maxLines: 1,
          )
        ],
      ),
      padding: EdgeInsets.only(left: 20, right: 20),
    );
  }
}
