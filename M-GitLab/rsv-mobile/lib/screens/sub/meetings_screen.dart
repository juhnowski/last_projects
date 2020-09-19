import 'package:flutter/material.dart';
import 'package:rsv_mobile/widgets/home/meeting_item.dart';
import 'package:rsv_mobile/widgets/home/user_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rsv_mobile/screens/chat/chat_open_screen.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:rsv_mobile/models/member.dart';

class MeetingsScreen extends StatelessWidget {
  final Member _user = Member(users[1]);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/homebg.png'), fit: BoxFit.cover),
          color: Color(0xffe5e5e5)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Встречи'),
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.only(right: 10),
                icon: Icon(Icons.add),
                iconSize: 30,
                onPressed: () {
//                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditMeetingScreen(username: _user.fullName, image: _user.userImage)));
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Container(
              child: new Column(
                children: <Widget>[
                  new Expanded(
                      child: new ListView(
                    padding: Margin.all(context),
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      UserImage(image: _user.userImage),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          _user.fullName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.solidComment),
                                  color: Color(0xff1184ED),
                                  iconSize: 30,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatOpenScreen()));
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
//                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(_user, false)));
                            },
                          )),
                      MeetingItem(new DateTime(2019, 8, 15, 13, 00),
                          MeetingItemStatus.normal, 'Буклет.pdf'),
                      MeetingItem(new DateTime(2019, 5, 21, 10, 30),
                          MeetingItemStatus.past, 'Отчет о тестировании.pdf'),
                      MeetingItem(
                        new DateTime(2019, 1, 17, 13, 00),
                        MeetingItemStatus.missed,
                        'Контракт о наставничестве.doc',
                        rating: 4,
                      ),
                    ],
                  ))
                ],
              ),
            ),
          )),
    );
  }
}
