import 'package:flutter/material.dart';
import 'package:rsv_mobile/models/chat/chat_room.dart';
import 'package:rsv_mobile/screens/chat/chat_open_screen.dart';
import 'package:rsv_mobile/widgets/home/user_image.dart';

class ChatItem extends StatefulWidget {
  final ChatRoom room;

  ChatItem(this.room);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  bool isLeaderRoom = false;
  String labelText;
  Color labelColor;

  @override
  void initState() {
    super.initState();
//    roomName = Provider.of<ChatService>(context, listen: false)
//        .getRoomName(widget.room.id);
    if (widget.room.isLeader) {
      labelText = 'Наставник';
      labelColor = Color(0xFFEF627D);
    }
    if (widget.room.isStudent) {
      labelText = null;
      labelColor = Color(0xFFEF627D);
    }
    if (widget.room.isCurator) {
      labelText = 'Куратор';
      labelColor = Color(0xFF1184ED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print('open room ${widget.room.id}');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatOpenScreen(roomId: widget.room.id)));
        },
        child: Container(
            child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            //  borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 100.0,
          child: Row(
            children: <Widget>[
              labelText != null
                  ? Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        UserImage(image: widget.room.image),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: new Container(
                              padding: const EdgeInsets.only(
                                  top: 4.0, bottom: 4.0, left: 5.0, right: 5.0),
                              decoration: new BoxDecoration(
                                  color: labelColor,
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(35.0))),
                              child: Center(
                                child: Text(labelText,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              )),
                        )
                      ],
                    )
                  : UserImage(image: widget.room.image),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color(0xfff2f2f2),
                              style: BorderStyle.solid))),
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  margin: EdgeInsets.only(left: 15.0),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.room.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      height: 1.1),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.room.lastMessageTimeFormatted,
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      )),
                      Container(
                          child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(widget.room.lastMessageText,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                )),
                          ),
                          (widget.room.newMessagesCount > 0)
                              ? Transform(
                                  transform: new Matrix4.identity()..scale(0.6),
                                  alignment: Alignment.centerRight,
                                  child: Chip(
                                      backgroundColor: Color(0xff1184ED),
                                      label: Text(widget.room.newMessagesCount
                                          .toString()),
                                      labelStyle: TextStyle(
                                          color: Colors.white, fontSize: 24)))
//                                      Container(
//                                        width: 22,
//                                        height: 22,
//                                        decoration: BoxDecoration(
//                                          color: Color(0xff1184ED),
//                                          borderRadius: BorderRadius.circular(20)
//                                        ),
//                                        child: Center(
//                                          child: Text(room.newMessagesCount.toString(), style: TextStyle(color: Colors.white, fontSize: 14),),
//                                        )
//                                      )
                              : Container()
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
