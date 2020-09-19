import 'package:flutter/material.dart';
import 'package:rsv_mobile/screens/sub/group_chat_screen.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class GroupItem extends StatelessWidget {
  final String _title;
  final String _subject;
  final int _users;
  final String _imgUrl;

  GroupItem(this._title, this._subject, this._users, this._imgUrl);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        padding: EdgeInsets.only(left: 20, right: 10),
        height: 120.0,
        child: Row(
          children: <Widget>[
            ClipRRect(
                child: Image.network(_imgUrl,
                    width: Size.groupImageSize(),
                    height: Size.groupImageSize(),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(8)),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Text(
                        _title,
                        style: TextStyle(
                          fontSize: 18.0,
                          height: 1.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      child: Text(
                        _subject,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      //padding: EdgeInsets.only(bottom: 10),
                      child: Text(_str_counter(_users),
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                              fontSize: 14)),
                    ),
                    Divider(
                      height: 1,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupChatScreen(_title, _imgUrl)));
      },
    );
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

class GroupInvitation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Margin.margin(context, def: 20),
        right: Margin.margin(context, def: 20),
        bottom: Margin.margin(context, def: 20),
      ),
      child: Column(
        children: <Widget>[
//          Container(
//            margin: EdgeInsets.only(bottom: 10),
//            child: Text(
//              'Вас пригласили в сообщество:',
//              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//            ),
//          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            height: 120.0,
            child: Row(
              children: <Widget>[
                ClipRRect(
                    child: Image.network(
                        'http://evolutionfund.ru/uploads/files/gallery/sletprosvetitelej/328.jpg',
                        width: Size.groupImageSize(),
                        height: Size.groupImageSize(),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(8)),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Группа 19.1',
                            style: TextStyle(
                              fontSize: 18.0,
                              height: 1.1,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          child: Text(
                            'Обсуждение',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(right: 10),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    'Вступить',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                  color: Color(0xff1184ED),
                ),
              )),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 10),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    'Отклонить',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                  color: Color(0xff1184ED),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
