import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rsv_mobile/widgets/home/stars_row.dart';

class MeetingItem extends StatelessWidget {
  final DateTime _date;
  final MeetingItemStatus _status;
  final _fileAttached;
  int _rating;
  String _strDate;
  bool _home;
  Color _color;

  MeetingItem(this._date, this._status, this._fileAttached,
      {bool home = false, Color color = Colors.white, int rating = 0}) {
    var dateFormat = new DateFormat.yMMMMd('ru');
    var timeFormat = new DateFormat.Hm('ru');
    _strDate = dateFormat.format(_date) + ' ' + timeFormat.format(_date);
    _home = home;
    _color = color;
    _rating = rating;
  }

  @override
  Widget build(BuildContext context) {
    Color bannerColor;
    if (_status == MeetingItemStatus.missed) {
      bannerColor = Color(0xff8F9398);
    } else if (_status == MeetingItemStatus.past) {
      bannerColor = Color(0xffEF627D);
    } else {
      bannerColor = Color(0XFF1184ED);
    }

    var item = Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        decoration: new BoxDecoration(
            color: _color, borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: new EdgeInsets.fromLTRB(10, 10, 40, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        //   color: Colors.white,
                        padding:
                            new EdgeInsets.only(left: 15.0, top: 5, bottom: 10),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: _home
                                  ? Text('Встреча',
                                      style: TextStyle(
                                          color: (_color == Colors.white)
                                              ? Color(0xffF38095)
                                              : Colors.blue,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20))
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    ),
                            ),
                            Container(
                              //margin: new EdgeInsets.only(bottom: 10.0),
                              child: Text(_strDate,
                                  style: new TextStyle(
                                      color: (_color == Colors.white)
                                          ? Color(0xff1184ED)
                                          : Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 10, top: 15),
                                  child: Text(
                                    'Тема встречи:',
                                    style: TextStyle(
                                        color: Color(0xff8F9398),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Text(
                                  'Обсуждение корпоративного бизнес-плана',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10, top: 15),
                                  child: Text(
                                    'Прикрепленные файлы:',
                                    style: TextStyle(
                                        color: Color(0xff8F9398),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Text(
                                  _fileAttached,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    _home
                        ? IconButton(
                            icon: Icon(
                              FontAwesomeIcons.solidCalendarCheck,
                              size: 46,
                              color: (_color == Colors.white)
                                  ? Color(0xffF38095)
                                  : Colors.white,
                            ),
                            onPressed: () {
//                                Navigator.push(context, MaterialPageRoute(builder: (context) => MeetingsScreen()));
                            },
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                    (_rating > 0 && !_home)
                        ? Container(
                            padding: EdgeInsets.only(top: 20),
                            child: StarsRow(20, false, _rating),
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),

                    //  (_status == MeetingItemStatus.past) ? Container(child: Text('задачи'),) : Container()
                  ],
                ),
              ),
            ]));

    var bannerText =
        (_status != MeetingItemStatus.missed) ? 'Пропущена' : 'Прошедшая';
    if (_status == MeetingItemStatus.normal) {
      bannerText = 'Запланирована';
    }
    var banner = Positioned(
      bottom: -40,
      right: -60,
      child: Container(
          transform: Matrix4.rotationZ(-math.pi / 4),
          width: 200,
          height: 40,
          color: bannerColor,
          child: Center(
              child: Text(
            bannerText,
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700),
          ))),
    );

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

enum MeetingItemStatus { normal, past, missed }
