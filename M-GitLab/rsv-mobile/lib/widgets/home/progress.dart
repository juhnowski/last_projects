import 'package:flutter/material.dart';
//import 'package:rsv_mobile/widgets/home/progress_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Progress extends StatelessWidget {
  final double _flagPos = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 30),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ProgressItem(
                          'Сессия', FontAwesomeIcons.solidComments, 'янв'),
                      ProgressItem('Вестник', FontAwesomeIcons.bookOpen, 'фев'),
                      ProgressItem('Опрос', FontAwesomeIcons.chartBar, 'мар'),
                      ProgressItem(
                          'Сессия', FontAwesomeIcons.solidComments, 'янв'),
                      ProgressItem('Вестник', FontAwesomeIcons.bookOpen, 'фев'),
                      ProgressItem('Опрос', FontAwesomeIcons.chartBar, 'мар'),
                      ProgressItem(
                          'Сессия', FontAwesomeIcons.solidComments, 'янв'),
                      ProgressItem('Вестник', FontAwesomeIcons.bookOpen, 'фев'),
                      ProgressItem('Опрос', FontAwesomeIcons.chartBar, 'мар'),
                      ProgressItem(
                          'Сессия', FontAwesomeIcons.solidComments, 'янв'),
                      ProgressItem('Вестник', FontAwesomeIcons.bookOpen, 'фев'),
                      ProgressItem('Опрос', FontAwesomeIcons.chartBar, 'мар'),
                    ],
                  ),
                  Positioned(
                      bottom: 50,
                      left: 20,
                      child: Container(
                        height: 24,
                        width: 2000,
                        //color: Colors.purpleAccent,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 6),
                              height: 4,
                              width: 2000,
                              color: Color(0xff7CBBF5),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 6),
                              height: 4,
                              width: _flagPos,
                              color: Color(0xff006CCE),
                            ),
                            Positioned(
                                left: _flagPos,
                                bottom: 6,
                                child: Container(
                                  height: 30,
                                  width: 15,
                                  // color: Colors.purpleAccent,
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 24,
                                        left: 0,
                                        child: Transform(
                                          transform:
                                              Matrix4.rotationZ(-3.14 / 2),
                                          child: ClipPath(
                                            clipper: TriangleClipper(),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xff006CCE),
                                              ),
                                              width: 12,
                                              height: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 2,
                                        decoration: BoxDecoration(
                                            color: Color(0xffF38095),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4),
                                                topRight: Radius.circular(4))),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              width: 20,
              height: 150,
              child: Container(
                padding: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.2, 0.9],
                        colors: [Colors.white, Colors.white])),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff006CCE),
                ),
              ),
            ),
          ],
        ));
  }
}

class ProgressItem extends StatelessWidget {
  final String _title;
  final IconData _icon;
  final String _month;

  ProgressItem(this._title, this._icon, this._month);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            _icon,
            color: Colors.blue,
          ),
          Text(_title),
          Container(
            color: Colors.blue,
            height: 16,
            width: 2,
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
