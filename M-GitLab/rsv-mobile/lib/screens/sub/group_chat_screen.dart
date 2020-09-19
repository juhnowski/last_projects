import 'package:flutter/material.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';
import 'dart:core';
import 'package:rsv_mobile/screens/sub/group_open_screen.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class GroupChatScreen extends StatelessWidget {
  final String _imgUrl;
  final String _name;

  GroupChatScreen(this._name, this._imgUrl);

  @override
  Widget build(BuildContext context) {
    return BackgroundedScaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Icon(Icons.info), Text('Информация')],
                    ),
                    value: [context, GroupOpenScreen(_name, _imgUrl)],
                  )
                ];
              },
            )
          ],
          title: Row(
            children: <Widget>[
              ClipRRect(
                  child: Image.network(_imgUrl,
                      width: 40.00, height: 40.0, fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(8)),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  _name,
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: Margin.all(context, def: 20),
                children: messagesList(),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xfff5f5f5)))),
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Текст сообщения'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Icon(Icons.send, color: Color(0xff1184ED)),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Icon(Icons.attach_file, color: Color(0xff1184ED)),
                    )
                  ],
                ))
          ],
        ));
  }

  void _select(data) {
    var context = data[0];
    var fn = data[1];
    Navigator.push(context, MaterialPageRoute(builder: (context) => fn));
  }

  List<Widget> messagesList() {
    List<Widget> messages = [];
//    var random = Random();
//    _messages.forEach((el){
//      bool toMe = random.nextBool();
//      messages.add(Align(
//          alignment: toMe ? Alignment.centerLeft : Alignment.centerRight ,
//          child: ChatBubble(el, toMe, name: 'Генадий Антонов',)
//      ));
//    });

    return messages;
  }
}
