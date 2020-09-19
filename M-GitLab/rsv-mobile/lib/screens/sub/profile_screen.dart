import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/blocs/chat_bloc.dart';
import 'package:rsv_mobile/models/chat/chat_room_member.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rsv_mobile/widgets/home/custom_button.dart';
import 'package:rsv_mobile/widgets/home/user_image.dart';
import 'package:rsv_mobile/screens/chat/chat_open_screen.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  final ChatRoomMember _user;
  final bool _me;
  final String chatRoomId;

  ProfileScreen(this._user, this._me, { this.chatRoomId });

  List<Widget> _socialLinks() {
    List<Widget> items = [];
    if (_user.socialVk != null) {
      items.add(InkWell(
        onTap: () {
          launch(_user.socialVk);
        },
        child: CircleIcon(FontAwesomeIcons.vk, Color(0xff4a76a8)),
      ));
    } else {
      items.add(CircleIcon(FontAwesomeIcons.vk, Color(0xFFC4C4C4)));
    }
    if (_user.socialOk != null) {
      items.add(InkWell(
        onTap: () {
          launch(_user.socialOk);
        },
        child: CircleIcon(FontAwesomeIcons.odnoklassniki, Color(0xffee8208)),
      ));
    } else {
      items.add(CircleIcon(FontAwesomeIcons.odnoklassniki, Color(0xFFC4C4C4)));
    }
    if (_user.socialIg != null) {
      items.add(InkWell(
        onTap: () {
          launch(_user.socialIg);
        },
        child: CircleIcon(FontAwesomeIcons.instagram, Color(0xffd62976)),
      ));
    } else {
      items.add(CircleIcon(FontAwesomeIcons.instagram, Color(0xFFC4C4C4)));
    }
    if (_user.socialFb != null) {
      items.add(InkWell(
        onTap: () {
          launch(_user.socialFb);
        },
        child: CircleIcon(FontAwesomeIcons.facebookF, Color(0xff3b5998)),
      ));
    } else {
      items.add(CircleIcon(FontAwesomeIcons.facebookF, Color(0xFFC4C4C4)));
    }
    if (_user.socialYt != null) {
      items.add(InkWell(
        onTap: () {
          launch(_user.socialYt);
        },
        child: CircleIcon(FontAwesomeIcons.youtube, Color(0xffff0000)),
      ));
    } else {
      items.add(CircleIcon(FontAwesomeIcons.youtube, Color(0xFFC4C4C4)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    List<String> subTitles = [];
    if (_user.age != null) {
      subTitles.add(_user.age);
    }
    if (_user.location != null) {
      subTitles.add(_user.location);
    }

    var _actions = <Widget>[];
    if (_me) {
      _actions.add(IconButton(
          padding: EdgeInsets.only(right: 40),
          icon: Icon(
            FontAwesomeIcons.signOutAlt,
            size: 30,
            color: Color(0xffEF627D),
          ),
          onPressed: () async {
            await Provider.of<NetworkService>(context, listen: false)
                .authLogout();
//            Navigator.popAndPushNamed(context, '/login');
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/login', (Route<dynamic> route) => false);
          }));
    }

    return DecoratedBox(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/homebg.png'), fit: BoxFit.cover),
          color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            elevation: 0.8,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
            title: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    if (chatRoomId != null) {
                      Provider.of<ChatBLoC>(context, listen: false).openRoom(chatRoomId);
                    }
                    Navigator.pop(context);
                  },
                ),
                new Text('Профиль',
                    style: new TextStyle(color: Color(0xff1184ED))),
              ],
            ),
            actions: _actions
//          actions: <Widget>[
//
//                : IconButton(
//                    padding: EdgeInsets.only(right: 40),
//                    icon: Icon(
//                      FontAwesomeIcons.solidComment,
//                      size: 30,
//                    ),
//                    onPressed: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  ChatOpenScreen(chatUserId: _user.userId)));
//                    })
//          ],
            ),
        body: SafeArea(
            child: Container(
          child: ListView(
            padding: Margin.all(context, def: 20),
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    UserImage(image: _user.avatar, size: Size.userImageLarge()),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        _user.fullName,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        subTitles.join((', ')),
                        style: TextStyle(fontSize: FontSize.subtitle()),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 6,
                          child: _me || chatRoomId != null
                              ? Container()
                              : CustomButton(
                                  color: Color(0xFF1184ED),
                                  text: 'Написать',
                                  onPressed: () {
//                                    if (chatRoomId != null) {
//                                      Provider.of<ChatBLoC>(context, listen: false).openRoom(chatRoomId);
//                                      Navigator.pop(context);
//                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatOpenScreen(
                                                      chatUserId: _user.userId)));
//                                    }
                                  }),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
//                  ProfileInfoRow('Вся инфа', jsonEncode(_user.profileInfo)),
//                  ProfileInfoRow('Дата рождения', _user.profileInfo.containsKey('birthday') ? _user.profileInfo['birthday'] : ''),
              ProfileInfoRow('О себе', _user.about ?? '-'),
              ProfileInfoRow('Сфера деятельности', _user.activity?.join(',') ?? '-'),
              ProfileInfoRow('Образование', _user.education ?? '-'),
//                  ProfileInfoRow('Девиз', 'Ни шагу назад'),
//                  ProfileInfoRow('Интересы', 'Книги, музыка, айкидо, м1, пауэрлифтинг, гольф, крикет, ставки на спорт, иностранный язык'),
//                  ProfileInfoRow('Стремлюсь быть', 'Web-разработчик'),
//                  ProfileInfoRow('Учеба', 'Изучал Геотехника в МСГУ Изучал Городское строительство'),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _socialLinks(),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String _label;
  final String _content;

  ProfileInfoRow(this._label, this._content);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _label + ':',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: FontSize.body()),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _content,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color(0xff979797),
                          fontSize: FontSize.body()),
                    ),
                  )
                ],
              ),
            ),
            Divider()
          ],
        ));
  }
}

class CircleIcon extends StatelessWidget {
  final IconData _icon;
  final Color _color;

  CircleIcon(this._icon, this._color);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
      child: Icon(
        _icon,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}
