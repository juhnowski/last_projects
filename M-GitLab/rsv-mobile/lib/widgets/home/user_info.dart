import 'package:flutter/material.dart';
import 'package:rsv_mobile/models/chat/chat_room_member.dart';
import 'package:rsv_mobile/screens/sub/profile_screen.dart';
import 'package:rsv_mobile/widgets/home/user_image.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class UserInfo extends StatelessWidget {
  final ChatRoomMember _user;
  final Widget bottom;
  final bool me;
  final bool leader;

  UserInfo(this._user, {this.bottom, this.me = false, this.leader = false});

  String _userBottomText() {
    var items = <String>[];
    if (_user.age != null) {
      items.add(_user.age);
    }
    if (_user.location != null) {
      items.add(_user.location);
    }
    return items.join(' ● ');
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: !_user.isLoaded ? null :() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(_user, me)));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 20, 10, 0),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: !_user.isLoaded ? Center(child: CircularProgressIndicator(),)
           : Row(
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  UserImage(image: _user.avatar, size: Size.userImageSize(),),
                  leader ?
                  Positioned(
                    bottom: -25,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(top: 5),
                        width: 60,
                        height: 20,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: Color(0xffEF627D),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(child: Text('Наставник', style: TextStyle(color: Colors.white, fontSize: FontSize.small()-2)),)
                    ),
                  ) : Container(width: 0, height: 0,)
                ],
              ),
              Expanded(
                child: new Container(
                  padding: new EdgeInsets.only(left: 15.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        child: new Align(
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            _user.fullName,
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ),
                      //new Expanded(child: new Container()),
                      new Container(
//                          padding: new EdgeInsets.only(top: 20, bottom: 5.0),
                          child: new Align(
                        alignment: Alignment.centerLeft,
                        child: bottom != null
                            ? bottom
                            : Text(
                                _userBottomText(),
                                style: new TextStyle(
                                    color: Color(0xFF979797), fontSize: 16.0),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
