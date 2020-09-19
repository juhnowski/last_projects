import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmilesRow extends StatefulWidget {
  final double _size;
  final bool _clickable;
  final int rating;
  final Color color;
  final Function onChange;
  static const Color defaultColor = Color(0xffFFD633);
  SmilesRow(this._size, this._clickable, this.rating,
      {this.onChange, this.color = defaultColor})
      : assert(onChange != null);

  @override
  State<StatefulWidget> createState() => SmilesRowState();
}

class SmilesRowState extends State<SmilesRow> {
  int rating;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
              child: RatingSmile.forRate(1, rating, size: widget._size),
              onTap: () {
                if (widget._clickable) {
                  _rate(1);
                }
              }),
          GestureDetector(
              child: RatingSmile.forRate(2, rating, size: widget._size),
              onTap: () {
                if (widget._clickable) {
                  _rate(2);
                }
              }),
          GestureDetector(
              child: RatingSmile.forRate(3, rating, size: widget._size),
              onTap: () {
                if (widget._clickable) {
                  _rate(3);
                }
              }),
        ],
      ),
    );
  }

  _rate(int index) {
    setState(() {
      rating = index;
    });
    widget.onChange(rating);
  }
}

class RatingSmile extends StatelessWidget {
  final bool _fill;
  final double size;
  Color get _color => _fill ? Color(0xFFFFD633) : Color(0xFFCCCCCC);
  final IconData _icon;

  RatingSmile(this._icon, this._fill, {this.size = 50.0});

  static RatingSmile forRate(int value, int rating, {double size = 50.0}) {
    var _fill = value == rating;
    IconData icon;
    switch (value) {
      case 1:
        icon = FontAwesomeIcons.frown;
        break;
      case 2:
        icon = FontAwesomeIcons.meh;
        break;
      case 3:
        icon = FontAwesomeIcons.smile;
        break;
    }
    return RatingSmile(icon, _fill, size: size);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(_icon, color: _color, size: size),
    );
  }
}
