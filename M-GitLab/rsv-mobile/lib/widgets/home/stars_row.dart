import 'package:flutter/material.dart';

class StarsRow extends StatefulWidget {
  final double _size;
  final bool _clickable;
  final int i;
  final Color color;
  static const Color defaultColor = Color(0xffFFD633);
  StarsRow(this._size, this._clickable, this.i, {this.color = defaultColor});

  @override
  State<StatefulWidget> createState() {
    return StarsRowState(_size, _clickable, i, color);
  }
}

class StarsRowState extends State<StarsRow> {
  final double _size;
  final bool _clickable;
  final Color _color;
  int i;
  StarsRowState(this._size, this._clickable, this.i, this._color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
            child: RatingStar((i > 0), _size, _color),
            onTap: () {
              if (_clickable) {
                _rate(1);
              }
            }),
        GestureDetector(
            child: RatingStar((i > 1), _size, _color),
            onTap: () {
              if (_clickable) {
                _rate(2);
              }
            }),
        GestureDetector(
            child: RatingStar((i > 2), _size, _color),
            onTap: () {
              if (_clickable) {
                _rate(3);
              }
            }),
        GestureDetector(
            child: RatingStar((i > 3), _size, _color),
            onTap: () {
              if (_clickable) {
                _rate(4);
              }
            }),
        GestureDetector(
            child: RatingStar((i > 4), _size, _color),
            onTap: () {
              if (_clickable) {
                _rate(5);
              }
            }),
      ],
    );
  }

  _rate(int index) {
    setState(() {
      i = index;
    });
  }
}

class RatingStar extends StatelessWidget {
  final bool _fill;
  final double _size;
  final Color _color;

  RatingStar(this._fill, this._size, this._color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_size / 10),
      child: Icon(
        Icons.star,
        color: _fill ? _color : _color.withOpacity(0.3),
        size: _size,
      ),
    );
  }
}
