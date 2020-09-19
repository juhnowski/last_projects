import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/blocs/chat_bloc.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/activities/meeting.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/models/files.dart';
import 'package:rsv_mobile/repositories/events_repository.dart';
import 'package:rsv_mobile/repositories/meetings_repository.dart';
import 'package:rsv_mobile/repositories/room_member_repository.dart';
import 'package:rsv_mobile/repositories/tasks_repository.dart';
import 'package:rsv_mobile/screens/home/home_screen.dart';
import 'package:rsv_mobile/screens/home/news_screen.dart';
import 'package:rsv_mobile/screens/home/chat_screen.dart';
import 'package:rsv_mobile/screens/sub/questionnaires_screen.dart';
import 'package:rsv_mobile/screens/sub/users_list_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rsv_mobile/services/calendars_manager.dart';
import 'package:rsv_mobile/services/chat_service.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:rsv_mobile/widgets/meeting/meeting_rate.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  StreamSubscription<Activity> rateSubscription;

  final List<Widget> _children = [
    HomeScreen(),
    NewsScreen(),
    ChatScreen(),
    UsersListScreen()
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    rateSubscription = Provider.of<Activities>(context, listen: false)
        .rateActivities
        .listen((activity) {
      if (activity != null) {
        print('activity ${activity.id}');
        _showModalSheet(activity);
      }
    });
  }

  @override
  void dispose() {
    print('dispose mainstate');
    rateSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print('app is paused!');
    }
    if (state == AppLifecycleState.resumed) {
      print('app is resumed!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: DecoratedBox(
            child: Container(
              child: _children[_currentIndex],
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/homebg.png'),
                    fit: BoxFit.cover)),
          )),
          bottomNavigationBar: BottomNavigationBar(
              unselectedFontSize: 12,
              selectedFontSize: 12,
              iconSize: Size.iconSize(),
              selectedItemColor: Color(0xff63A1ff),
              unselectedItemColor: Color(0xff7CBBFc),
              showUnselectedLabels: true,
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: BottomNavBarIcon(FontAwesomeIcons.home),
                    title: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text('Главная'),
                    )),
                BottomNavigationBarItem(
                    icon: BottomNavBarIcon(FontAwesomeIcons.bolt),
                    title: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text('Актуально'),
                    )),
                BottomNavigationBarItem(
                    icon: Consumer<ChatBLoC>(
                      builder: (context, chat, child) {
                        return StreamBuilder(
                            initialData: 0,
                            stream: chat.newMessagesCount,
                            builder: (context, snapshot) {
                              return BottomNavBarIcon(
                                  FontAwesomeIcons.solidComments,
                                  notifications: snapshot.data);
                            });
                      },
                    ),
                    title: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text('Чаты'),
                    )),
//                BottomNavigationBarItem(
//                    icon: BottomNavBarIcon(Icons.assessment),
//                    title: Container(
//                      margin: EdgeInsets.only(top: 5),
//                      child: Text('Опросы'),
//                    )),
                BottomNavigationBarItem(
                    icon: BottomNavBarIcon(FontAwesomeIcons.userFriends),
                    title: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text('Участники'),
                    )),
              ])),
    );
  }

  void _showModalSheet(Meeting meeting) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
//          return RateMeeting();
          return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Container(
                  padding:
                      EdgeInsets.only(left: 16, top: 12, bottom: 24, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 24),
                        alignment: Alignment.center,
                        child: Container(
                          height: 4,
                          width: 72,
                          decoration: BoxDecoration(
                              color: Color(0xFF1184ED),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child:
                              RateMeeting(meeting, withDate: true, onRate: () {
                            Navigator.pop(context);
                          }),
                        ),
                      ),
                    ],
                  )));
        });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class BottomNavBarIcon extends StatelessWidget {
  int _counter;
  final IconData _icon;

  BottomNavBarIcon(this._icon, {notifications = 0}) {
    this._counter = notifications;
  }

  @override
  Widget build(BuildContext context) {
    Widget _notification = Positioned(
      right: 0,
      child: new Container(
        padding: EdgeInsets.all(1),
        decoration: new BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        constraints: BoxConstraints(
          minWidth: 12,
          minHeight: 12,
        ),
        child: new Text(
          '$_counter',
          style: new TextStyle(
            color: Colors.white,
            fontSize: 8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        Icon(_icon),
        (_counter > 0)
            ? _notification
            : Container(
                height: 0,
                width: 0,
              ),
      ],
    );
  }
}
