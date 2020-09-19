import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/chat/chat_room_message.dart';
import 'package:rsv_mobile/models/files.dart';
import 'package:rsv_mobile/models/profile_file.dart';
import 'package:rsv_mobile/services/download_manager.dart';

class ChatBubble extends StatefulWidget {
  final ChatRoomMessage _message;
  final bool _toMe;
  String _name;
  ChatBubble(this._message, this._toMe, {String name}) {
    this._name = name;
  }

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: buildMessages(),
    );
  }

  List<Widget> buildMessages() {
    var messages = <Widget>[
      textMessage(),
    ];
    if (widget._message.attachments?.isNotEmpty ?? false) {
      messages.addAll(widget._message.attachments.map(fileMessage));
    }
    return messages;
  }

  Widget textMessage() {
    return widget._message.text.length == 0
        ? Container()
        : Container(
            margin: widget._toMe
                ? EdgeInsets.only(bottom: 20, right: 40)
                : EdgeInsets.only(bottom: 20, left: 40),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: widget._toMe ? Color(0xfff2f2f2) : Color(0xff1184ED),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (widget._name != null && widget._toMe)
                        ? Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              widget._name,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          )
                        : Container(width: 0, height: 0),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(widget._message.text,
                          style: TextStyle(
                              color: widget._toMe
                                  ? Color(0xff2A2A2A)
                                  : Colors.white,
                              height: 1.5,
                              fontSize: 14)),
                    )
                  ],
                )),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 15),
                    child: new Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        widget._message.messageTime,
//                        widget._message.createdAt.toIso8601String(),
                        style: TextStyle(
                            color: widget._toMe ? Colors.grey : Colors.white,
                            fontSize: 12),
                      ),
                    ))
              ],
            ));
  }

  bindAndDownloadFile(ProfileFile file) async {
    await Provider.of<Files>(context, listen: false).saveToMe(file);
    Provider.of<DownloadManager>(context, listen: false).downloadFile(file.url);
  }

  Widget _downloadAlert(context, ProfileFile file) {
    return AlertDialog(
      title: new Text("Сохранить файл?"),
      content: new Text("Вы сможете открыть файл, после окончания загрузки."),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Сохранить"),
          onPressed: () {
            bindAndDownloadFile(file);
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text("Отмена"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget fileMessage(ProfileFile file) {
    print('file message');
    print(file.id);
    print(file.url);
    print(file.name);
    return Container(
        margin: widget._toMe
            ? EdgeInsets.only(bottom: 20, right: 40)
            : EdgeInsets.only(bottom: 20, left: 40),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: widget._toMe ? Color(0xfff2f2f2) : Color(0xff1184ED),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (widget._name != null && widget._toMe)
                    ? Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          widget._name,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      )
                    : Container(width: 0, height: 0),
                Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Flex(
                      mainAxisSize: MainAxisSize.min,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return _downloadAlert(context, file);
                              },
                            );
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: new BoxDecoration(
                                color: widget._toMe
                                    ? Color(0xffE5E5E5)
                                    : Color(0xff7CBBF5),
                                shape: BoxShape.circle,
                              ),
                              child: new Icon(
                                FontAwesomeIcons.fileAlt,
                                color: widget._toMe
                                    ? Color(0xff676767)
                                    : Colors.white,
                              )),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(file.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: widget._toMe
                                          ? Color(0xff2A2A2A)
                                          : Colors.white,
                                      height: 1.5,
                                      fontSize: 14)),
                              Text(file.fileSize,
                                  style: TextStyle(
                                      color: widget._toMe
                                          ? Color(0xff2A2A2A)
                                          : Color.fromRGBO(255, 255, 255, 0.6),
                                      fontSize: 16)),
                            ],
                          ),
                        ))
                      ],
                    ))
              ],
            )),
            Container(
                margin: EdgeInsets.only(left: 10, top: 15),
                child: new Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget._message.messageTime,
                    style: TextStyle(
                        color: widget._toMe ? Colors.grey : Colors.white,
                        fontSize: 12),
                  ),
                ))
          ],
        ));
  }
}
