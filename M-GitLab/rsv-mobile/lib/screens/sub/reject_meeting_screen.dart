import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/blocs/chat_bloc.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/chat/chat_room_member.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/models/user.dart';
import 'package:rsv_mobile/repositories/room_member_repository.dart';
import 'package:rsv_mobile/screens/activities/create_meeting_screen.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rsv_mobile/widgets/datetimepicker.dart';

class RejectMeetingScreen extends StatefulWidget {
  final Activity meeting;

  RejectMeetingScreen(this.meeting);

  @override
  _RejectMeetingScreenState createState() => _RejectMeetingScreenState();
}

class _RejectMeetingScreenState extends State<RejectMeetingScreen> {
  ChatRoomMember meetWithUser;

  TextEditingController rejectReasonController = new TextEditingController();
  String rejectReasonError;

  _valid() {
    if (rejectReasonController.text.isEmpty) {
      setState(() {
        rejectReasonError = "Обязательное поле";
      });
      return false;
    } else
      return true;
  }

  rejectMeeting() async {
    if (_valid()) {
      String reason = rejectReasonController.text.toString();
      var newStatus = await Provider.of<Activities>(context, listen: false)
          .rejectActivity(widget.meeting, reason);
      if (newStatus == ActivityStatus.rejected) {
        Provider.of<ChatBLoC>(context, listen: false).sendMessageToPair(
            'Автосообщение: Встреча "${widget.meeting.theme}", предложенная на ${new DateFormat('dd.MM.y').format(widget.meeting.dateTime.toLocal())}, отклонена.');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
              ),
            ),
            Expanded(
              child: Center(
                  child: Text('Отмена встречи',
                      style: TextStyle(
                          color: Color(0xFF2A2A2A),
                          fontWeight: FontWeight.w600,
                          fontSize: 17))),
            ),
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    await rejectMeeting();
                  },
                ),
              ),
            ),
//            Container(
//              child: Align(
//                alignment: Alignment.centerRight,
//                child: MaterialButton(
//                  onPressed: () {
//                  },
//                  child: Text(
//                    'Отправить',
//                    style: TextStyle(
//                        color: Color(0xFF1184ED),
//                        fontWeight: FontWeight.w600,
//                        fontSize: 17),
//                  ),
//                ),
//              ),
//            )
          ],
        ),
      ),

//      AppBar(
//          title: Row(
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          FlatButton(
//            onPressed: () {
//              rejectMeeting();
//            },
//            child: Text(
//              'Отправить',
//              style: TextStyle(color: Color(0xff1184ED), fontSize: 18),
//            ),
//          ),
//        ],
//      )),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectUser(
                      user: Provider.of<RoomMemberRepository>(context,
                              listen: false)
                          .getMember(Provider.of<NetworkService>(context, listen: false)
                              .user
                              .group
                              .studentId)),
                  DateInput(
                      date: widget.meeting.dateTime,
                      labelText: 'Дата',
                      labelStyle: const TextStyle(
                          fontSize: 18, color: const Color(0xFF8F9398))),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xFFF2F2F2))),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(children: <Widget>[
                      Text(widget.meeting.theme,
                          style: const TextStyle(
                              fontSize: 18, color: const Color(0xFF8F9398)))
                    ]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xFFF2F2F2))),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          widget.meeting.description,
                          style: const TextStyle(
                              fontSize: 18, color: const Color(0xFF8F9398)),
                        )),
                      ],
                    ),
                  ),
//              Container(
//                child: RaisedButton(onPressed: (){},
//                child: Row(
//                  children: <Widget>[
//                    Text('Добавить материалы', style: TextStyle(color: Colors.blue, fontSize: 16),),
//                    Container(
//                      padding: EdgeInsets.symmetric(vertical: 10),
//                      child: Icon(FontAwesomeIcons.paperclip, size: 18, color: Colors.blue,),
//                    )
//                  ],
//                ),
//                ),
//              ),
                  // _SelectUser(),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: rejectReasonController,
                  minLines: 1,
                  maxLines: 10,
                  maxLength: 200,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1184ED)),
                      labelText: 'Пожалуйста, напишите причину отмены встречи'),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
