import 'package:flutter/material.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';
import 'package:rsv_mobile/widgets/groups/select_users_button.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:rsv_mobile/screens/sub/group_users_screen.dart';

class GroupOpenScreen extends StatelessWidget {
  final String _imgUrl;
  final String _title;
  String _subject = 'Тема сообщества';
  final int _users = 113;

  GroupOpenScreen(this._title, this._imgUrl);

  @override
  Widget build(BuildContext context) {
    return BackgroundedScaffold(
        appBar: AppBar(
          title: Text('Сообщества'),
        ),
        body: Container(
          padding: Margin.all(context),
          child: Column(
            children: <Widget>[
              GroupHeader(_imgUrl, _title, _subject, _users),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.only(
                          left: 35, right: 35, top: 12, bottom: 12),
                      color: Color(0xff1184ED),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GroupUsersScreen()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text('Участники',
                          style: TextStyle(color: Colors.white)),
                    ),
                    RaisedButton(
                      color: Color(0xff1184ED).withOpacity(0.4),
                      onPressed: () {},
                      child: Text(
                        'Вы подписаны',
                        style: TextStyle(color: Colors.white),
                      ),
                      padding: EdgeInsets.only(
                          left: 35, right: 35, top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Тема: ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text('Вопросы и обсуждения')
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Задача: ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Flexible(
                            child: Text(
                              'Решение организационных и методологических вопросов по наставничеству.',
                              // overflow: TextOverflow.fade,
                              maxLines: 4,
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SelectUsersButton()
            ],
          ),
        ));
  }
}

class GroupHeader extends StatelessWidget {
  final String _imgUrl;
  final String _title;
  final String _subject;
  final int _users;

  GroupHeader(this._imgUrl, this._title, this._subject, this._users);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        height: 400,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(_imgUrl), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Color.fromARGB(400, 0, 0, 0),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      _title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Text(_subject, style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_str_counter(_users),
                      style: TextStyle(
                        color: Colors.white,
                      ))
                ],
              )
            ],
          ),
        ));
  }
}

String _str_counter(int n) {
  int r = ((n % 100) > 4 && (n % 100) < 21) ? 5 : n % 10;
  switch (r) {
    case 1:
      return n.toString() + ' участник';
    case 2:
    case 3:
    case 4:
      return n.toString() + ' участника';
    default:
      return n.toString() + ' участников';
  }
}
