import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:rsv_mobile/screens/sub/questionnaire_open_screen.dart';

class QuestionnaireItem extends StatelessWidget {
  final String _name;
  final DateTime _date;
  final String _subject;
  final Color _color;
  String _strDate;
  final QuestionnaireStatus _status;
//
  QuestionnaireItem(
      this._name, this._subject, this._date, this._color, this._status) {
    var dateFormat = new DateFormat('dd.MM.yyyy');
    _strDate = dateFormat.format(_date);
  }

  @override
  Widget build(BuildContext context) {
    Color bannerColor;
    if (_status == QuestionnaireStatus.missed) {
      bannerColor = Color(0xffEF627D);
    } else if (_status == QuestionnaireStatus.past) {
      bannerColor = Color(0xff8F9398);
    } else {
      bannerColor = Color(0XFF1184ED);
    }

    var item = Container(
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color(0xffd6d7dB),
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                    blurRadius: 2)
              ],
              color: Color(0xffefefef),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: new EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Expanded(
                          child: new Container(
                            //color: Colors.white,
                            padding: new EdgeInsets.only(
                                left: 15.0, top: 5, bottom: 10),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: new Text(
                                    _name,
                                    style: new TextStyle(
                                        color: (_color == Color(0xff1184ED)
                                            ? Colors.black
                                            : _color),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w700),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                                new Container(
                                  margin: new EdgeInsets.only(bottom: 10.0),
                                  child: Text('Заполните анкету до ' + _strDate,
                                      style: new TextStyle(
                                          color: _color,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
//                                      Container(
//                                        margin: EdgeInsets.only(bottom: 10),
//                                        child: Text(
//                                          'Программа:',
//                                          style: TextStyle(
//                                              color: Color(0xff8F9398),
//                                              fontSize: 14,
//                                              fontWeight: FontWeight.w300),
//                                        ),
//                                      ),
//                                      Text(
//                                        '"Я - Наставник"',
//                                        style: TextStyle(fontSize: 14),
//                                      ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 10, top: 15),
                                      child: Text(
                                        'Цель опроса:',
                                        style: TextStyle(
                                            color: Color(0xff8F9398),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 30),
                                      child: Text(
                                        _subject,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        new Container(
                            padding: EdgeInsets.only(right: 10),
                            child: new Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _color.withOpacity(0.4)),
                            ))
                      ],
                    )),
              ]),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuestionnareOpenScreen()));
        },
      ),
    );

    var bannerText =
        (_status == QuestionnaireStatus.missed) ? 'Пропущен' : 'Прошедший';
    var banner = (_status != QuestionnaireStatus.normal)
        ? Positioned(
            bottom: -40,
            right: -40,
            child: Container(
                transform: Matrix4.rotationZ(-math.pi / 4),
                width: 140,
                height: 40,
                color: bannerColor,
                child: Center(
                    child: Text(
                  bannerText,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ))),
          )
        : Container();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: <Widget>[item, banner],
        ),
      ),
    );
  }
}

enum QuestionnaireStatus { normal, past, missed }
