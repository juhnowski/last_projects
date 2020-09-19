import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/chat/chat_room_member.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/widgets/datetimepicker.dart';
import 'package:rsv_mobile/widgets/home/user_image.dart';

class CreateMeetingScreen extends StatefulWidget {
  final ChatRoomMember meetWithUser;

  CreateMeetingScreen({this.meetWithUser});

  @override
  _CreateMeetingScreenState createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  String nameError;
  String descriptionError;
  DateTime date = new DateTime.now();
  final DateTime _now = new DateTime.now();

  _valid() {
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = "Обязательное поле";
      });
      return false;
    } else
      return true;
  }

  createMeeting() {
    if (_valid()) {
      String name = nameController.text.toString();
      String description = descriptionController.text.toString();
      String location = locationController.text.toString();
      Provider.of<Activities>(context, listen: false).createActivity(
          ActivityType.meeting, name, description, date, location);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              createMeeting();
            },
            child: Text(
              'Отправить',
              style: TextStyle(color: Color(0xff1184ED), fontSize: 18),
            ),
          ),
        ],
      )),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SelectUser(user: widget.meetWithUser, onChange: () {}),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: 'Тема встречи', errorText: nameError),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          alignLabelWithHint: true, labelText: 'Описание'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: locationController,
                      maxLines: 3,
                      decoration: InputDecoration(
                          helperText: 'Укажите адрес встречи',
                          alignLabelWithHint: true,
                          labelText: 'Место'),
                    ),
                  ),
                  DateInput(
                    onChange: (DateTime newDate) {
                      setState(() {
                        date = newDate;
                      });
                    },
                    date: date,
                    labelText: 'Выбрать дату',
                    minimumDate: _now,
                    maximumDate: DateTime(_now.year + 1, _now.month, _now.day),
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class SelectUser extends StatelessWidget {
  final ChatRoomMember user;
  final Function onChange;

  SelectUser({this.user, this.onChange});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: null,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    style: BorderStyle.solid, color: Color(0xfff2f2f2)))),
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            UserImage(image: user.avatar, size: 56),
//            Container(
//              height: 60,
//              width: 60,
//              child: ClipRRect(
//                borderRadius: BorderRadius.circular(30.0),
//                child: FadeInImage.assetNetwork(
//                  placeholder: 'assets/images/avatar.png',
//                  image: user != null ? user.avatar : null,
//                ),
//              ),
//            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(bottom: 6),
                      child: (user != null)
                          ? Text(
                              user.fullName,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )
                          : Text(
                              'C кем бы вы хотели встретиться?',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )),
                  Text(
                    (user != null) ? user.lastOnlineText : 'Выбрать',
                    style: TextStyle(color: Color(0xff8F9398)),
                  )
                ],
              ),
            )),

            //  Icon(Icons.arrow_forward_ios, color: Color(0xffD1D1D6),)
          ],
        ),
      ),
    );
  }
}
