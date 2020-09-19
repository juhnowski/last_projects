import 'package:flutter/material.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class ListButton extends StatelessWidget {
  final String _text;
  final IconData _icon;
  int _notifications;
  Widget _screen;

  ListButton(this._text, this._icon, {Widget screen, int notifications = 0}) {
    this._notifications = notifications;
    this._screen = screen;
  }

  @override
  Widget build(BuildContext context) {
    var _notification = Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(1),
        decoration:
            new BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        constraints: BoxConstraints(
          minWidth: 18,
          minHeight: 18,
        ),
        child: Center(
          child: Text(
            '$_notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ));

    return InkWell(
      onTap: () {
        if (_screen != null)
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => _screen));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: <Widget>[
            Container(
              child: Icon(
                _icon,
                color: Color(0xff1184ED),
                size: 40,
              ),
            ),
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 30),
                    padding: EdgeInsets.only(top: 30, bottom: 30),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xfff2f2f2)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _text,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: FontSize.h2()),
                        ),
                        Expanded(child: Container()),
                        if (_notifications > 0) _notification,
                        Icon(Icons.arrow_forward_ios, color: Color(0xffd1d1d6))
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
