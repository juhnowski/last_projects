import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/chat/chat_room_member.dart';
import 'package:rsv_mobile/models/user.dart';
import 'package:rsv_mobile/repositories/room_member_repository.dart';
import 'package:rsv_mobile/screens/sub/profile_screen.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rsv_mobile/widgets/home/user_image.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class UsersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Все участники'),
        ),
        body: SafeArea(
            child: DefaultTabController(
                length: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/homebg.png'),
                          fit: BoxFit.cover),
                      color: Colors.white),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: TabBar(
                      labelColor: Color(0xff1184ED),
                      tabs: [
                        Tab(text: 'Участники'),
                        Tab(text: 'Наставники'),
                      ],
                    ),
                    body: Consumer<NetworkService>(
                      builder: (context, networkService, child) {
                        var user = networkService.user;
                        if (user != null) {
                          return TabBarView(
                            children: [
                              Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: ListView.builder(
                                      padding: Margin.all(context),
                                      itemCount: user.group.students.length,
                                      itemBuilder: (context, i) => UserListItem(
                                          Provider.of<RoomMemberRepository>(
                                                  context)
                                              .getMember(
                                                  user.group.students[i]),
                                          'В сети 5 мин назад'))),
                              Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: ListView.builder(
                                      padding: Margin.all(context),
                                      itemCount: user.group.leaders.length,
                                      itemBuilder: (context, i) => UserListItem(
                                          Provider.of<RoomMemberRepository>(
                                                  context)
                                              .getMember(user.group.leaders[i]),
                                          'В сети 5 мин назад'))),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ))));
  }
}

class UserListItem extends StatelessWidget {
  final ChatRoomMember _user;
  final _bottom;
  UserListItem(this._user, this._bottom);

  @override
  Widget build(BuildContext context) {
    return _user.isNotFound
        ? Container()
        : InkWell(
            child: Container(
                padding: EdgeInsets.only(left: 20),
                child: new Container(
                  height: 75.0,
                  child: new Row(
                    children: <Widget>[
                      _user.isLoaded
                          ? UserImage(
                              image: _user.avatar,
                              size: 56,
                            )
                          : CircularProgressIndicator(),
                      Expanded(
                        child: new Container(
                          padding: new EdgeInsets.only(left: 15.0, top: 8),
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                child: new Align(
                                  alignment: Alignment.centerLeft,
                                  child: new Text(
                                    _user.isLoaded ? _user.fullName : '...',
                                    style: new TextStyle(
                                      color: Color(0xFF2A2A2A),
                                      fontSize: 16.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              new Container(
                                  padding: EdgeInsets.only(top: 8),
                                  child: new Align(
                                    alignment: Alignment.centerLeft,
                                    child: new Text(
                                      _user.lastOnlineText,
                                      style: new TextStyle(
                                          color: Color(0xFF676767),
                                          fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  )),
                              new Expanded(child: new Container()),
                              Divider()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          _user,
                          Provider.of<NetworkService>(context, listen: false).userId ==
                              _user.userId)));
            },
          );
  }
}
