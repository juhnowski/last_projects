import 'package:flutter/material.dart';
import 'package:rsv_mobile/widgets/home/labeled_icon.dart';

class ProgressItem extends StatelessWidget {
  final String _label;
  final IconData _icon;
  final String _month;
  bool _fill = false;
  bool _flag = false;

  ProgressItem(this._label, this._icon, this._month,
      {fill = false, flag = false}) {
    this._fill = fill;
    this._flag = flag;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.,
        children: <Widget>[
          LabeledIcon(_icon, _label),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 5),
            height: 30,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 3,
                  decoration: BoxDecoration(
                      color: Color(0xff1184ED),
                      borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 4,
                          color: _fill ? Color(0xff006CCE) : Color(0xff7CBBF5),
                        ),
                      ),
                      _flag
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  Container(
                                    width: 4,
                                    height: 17,
                                    decoration: BoxDecoration(color: Colors.blue
                                        // border: Border(bottom: BorderSide(color:Color(0xff7CBBF5), width: 4 ))
                                        ),
                                  ),
                                  Container(
                                    child: Transform(
                                      transform: Matrix4.rotationZ(-3.14 / 2),
                                      child: ClipPath(
                                        clipper: TriangleClipper(),
                                        child: Container(
                                          color: Colors.red,
                                          width: 10,
                                          height: 10,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ))
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(_month)
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
