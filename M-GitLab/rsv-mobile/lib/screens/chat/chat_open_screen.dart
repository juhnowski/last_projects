import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/blocs/chat_bloc.dart';
import 'package:rsv_mobile/models/chat/chat_room.dart';
import 'package:rsv_mobile/models/chat/chat_room_message.dart';
import 'package:rsv_mobile/models/files.dart';
import 'package:rsv_mobile/models/profile_file.dart';
import 'package:rsv_mobile/models/user.dart';
import 'package:rsv_mobile/repositories/room_member_repository.dart';
import 'package:rsv_mobile/screens/sub/profile_screen.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rsv_mobile/widgets/home/user_image.dart';
import 'package:rsv_mobile/widgets/chat/chat_bubble.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:rsv_mobile/screens/activities/create_meeting_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';

class ChatOpenScreen extends StatefulWidget {
//  List<String> _messages = ['Сообщение 1 и оно длиннее чем остальные для проверки поведения интерфейса. И вот что будет если добавить еще немного', 'Cообщение 2', 'Привет, как дела? ', 'Да вроде неплохо, а у тебя?', 'Хорошо все. спасибо', 'А по заданию как?'];
  final String roomId;
  final int chatUserId;

  ChatOpenScreen({this.roomId, this.chatUserId});

  @override
  _ChatOpenScreenState createState() => _ChatOpenScreenState();
}

class _ChatOpenScreenState extends State<ChatOpenScreen> {
  bool ready = false;

  @override
  void initState() {
    if (widget.roomId != null) {
      Provider.of<ChatBLoC>(context, listen: false).openRoom(widget.roomId);
      ready = true;
    } else if (widget.chatUserId != null) {
      Provider.of<ChatBLoC>(context, listen: false)
          .openRoomWithUser(widget.chatUserId);
      ready = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !ready
        ? Container()
        : Consumer<ChatBLoC>(builder: (context, chat, child) {
            return BackgroundedScaffold(
                appBar: AppBar(
                  titleSpacing: 0.0,
                  automaticallyImplyLeading: false,
                  elevation: 0.8,
                  title: StreamBuilder<ChatRoom>(
                      stream: chat.currentRoom,
                      initialData: null,
                      builder: (BuildContext context,
                          AsyncSnapshot<ChatRoom> snapshot) {
                        return Row(
                          children: !snapshot.hasData
                              ? <Widget>[]
                              : <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: const Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                      chat.closeCurrentRoom();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  GestureDetector(
                                    child: Row(
                                      children: <Widget>[
                                        UserImage(
                                          image: snapshot.data.image,
//                              image: chat.currentRoom,
                                          size: 40,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 12),
                                          child: Text(
                                            snapshot.data.name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      if (snapshot.data.isPersonal) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                      Provider.of<RoomMemberRepository>(
                                                              context,
                                                              listen: false)
                                                          .getMember(snapshot
                                                              .data.personId),
                                                      false,
                                                      chatRoomId: snapshot.data.id,
                                                    )));
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  snapshot.data.isLeader
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 9),
                                          child:
                                              AddMeetingButton(chat.leaderId))
                                      : Container(width: 0, height: 0),
//                            Container(
//                                padding: EdgeInsets.symmetric(horizontal: 9),
//                                child: Icon(
//                              Icons.search,
//                              size: 25,
//                            ))
                                ],
                        );
                      }),
                  backgroundColor: Colors.white,
                ),
                body: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
//              Pinned(),
                      StreamBuilder<List<ChatRoomMessage>>(
                          initialData: null,
                          stream: chat.messages,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ChatRoomMessage>> snapshot) {
                            return Expanded(
                              child: (!snapshot.hasData)
                                  ? LoadingMessagesHistory()
                                  : (snapshot.data.isEmpty)
                                      ? EmptyMessagesHistory()
                                      : messagesList(
                                          snapshot.data.reversed.toList(),
                                          padding: Margin.all(context, def: 20),
                                        ),
                            );
                          }),
                      Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Color(0xfff5f5f5)))),
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          child: MessageInput())
                    ],
                  ),
                ));
          });
  }

  ListView messagesList(List<ChatRoomMessage> messages,
      {EdgeInsetsGeometry padding}) {
    return ListView.builder(
      reverse: true,
      padding: padding,
      itemCount: messages.length,
      itemBuilder: (context, i) {
        bool isMine = messages[i].authorId !=
            Provider.of<NetworkService>(context, listen: false).userId;
        return Align(
            alignment: isMine ? Alignment.centerLeft : Alignment.centerRight,
            child: ChatBubble(messages[i], isMine));
      },
    );
  }
}

class EmptyMessagesHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 150,
          width: 150,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Color(0xfff2f2f2)),
          child: Icon(
            Icons.mail_outline,
            size: 60,
            color: Color(0xff676767),
          ),
        ),
        Text('В этом чате нет сообщений')
      ],
    ));
  }
}

class LoadingMessagesHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 150,
          width: 150,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Color(0xfff2f2f2)),
          child: Icon(
            Icons.mail_outline,
            size: 60,
            color: Color(0xff676767),
          ),
        ),
        Text('Загрузка истории сообщений')
      ],
    ));
  }
}

class Pinned extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: 5, horizontal: Margin.margin(context, def: 10)),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xfff5f5f5))),
        ),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Закрепленный документ',
                    style: TextStyle(
                        color: Color(0xff1184ed),
                        fontWeight: FontWeight.w700,
                        fontSize: FontSize.body()),
                  ),
                  Text(
                    'Document.pdf',
                    style: TextStyle(fontSize: FontSize.body()),
                  )
                ],
              ),
              IconButton(
                  icon: Icon(FontAwesomeIcons.times, color: Color(0xff1184ed)),
                  onPressed: () {}),
            ],
          ),
        ));
  }
}

class MessageInput extends StatefulWidget {
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final textMessageController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    textMessageController.dispose();
    super.dispose();
  }

  sendAttachment() async {
    var file = await FilePicker.getFile(type: FileType.ANY);
    var filesRepository = Provider.of<Files>(context, listen: false);
    ProfileFile uploadedFile = await filesRepository.uploadFile(file);
//      await filesRepository.saveToMe(uploadedFile); // ?if need to bind uploaded file
    Provider.of<ChatBLoC>(context, listen: false)
        .sendMessageToCurrentRoom(files: [uploadedFile]);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: textMessageController,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Текст сообщения'),
          ),
        ),
        SizedBox(
            height: 36.0,
            width: 36.0,
            child: IconButton(
                onPressed: () {
                  if (textMessageController.text.length > 0) {
                    Provider.of<ChatBLoC>(context, listen: false)
                        .sendMessageToCurrentRoom(
                            text: textMessageController.text);
                    textMessageController.clear();
                  }
                },
                icon: Icon(Icons.send, color: Color(0xff1184ED)))),
        SizedBox(
            height: 36.0,
            width: 36.0,
            child: IconButton(
                onPressed: () {
                  sendAttachment();
                },
                icon: Icon(Icons.attach_file, color: const Color(0xff1184ED)))),
      ],
    );
  }
}

class AddMeetingButton extends StatelessWidget {
  final int meetWithId;

  AddMeetingButton(this.meetWithId);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: const Color(0xff1184ED),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateMeetingScreen(
                        meetWithUser: Provider.of<RoomMemberRepository>(context,
                                listen: false)
                            .getMember(meetWithId))));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.handshake,
                size: 18,
                color: Colors.white,
              ),
              Icon(
                FontAwesomeIcons.plus,
                size: 10,
                color: Colors.white,
              ),
            ],
          )),
    );
  }
}
