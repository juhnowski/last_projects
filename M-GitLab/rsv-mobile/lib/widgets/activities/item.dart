import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/blocs/chat_bloc.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/activities/meeting.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/models/user.dart';
import 'package:rsv_mobile/repositories/room_member_repository.dart';
import 'package:rsv_mobile/screens/activities/single_activity_screen.dart';
import 'package:rsv_mobile/screens/sub/reject_meeting_screen.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rsv_mobile/widgets/UI/rounded_button.dart';
import 'package:rsv_mobile/widgets/activities/calendar_button.dart';
import 'package:rsv_mobile/widgets/activities/confirmation_description.dart';
import 'package:rsv_mobile/widgets/activities/date.dart';
import 'package:rsv_mobile/widgets/activities/label.dart';
import 'package:rsv_mobile/widgets/datetimepicker.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityItem extends StatelessWidget {
  final Axis axis;
  final Activity item;
  final Color backgroundColor = const Color(0xffF6F7FB);

  ActivityItem({this.item, this.axis});

  Color _color() {
    Color color;
    switch (item.status) {
      case ActivityStatus.completed:
        color = Color(0xFF979797);
        break;
      case ActivityStatus.missed:
        color = Color(0xFFFC3A51);
        break;
      default:
        color = ActivityAttribute.attributeOf(item.type).color;
    }
    return color;
  }

  List<Widget> _controls() {
    List<Widget> controls = [];
    if (item.dateTime != null && item.status == ActivityStatus.in_progress) {
      controls.add(Expanded(
          child: Container(
        margin: EdgeInsets.only(right: 10),
        child: ActivityCalendarButton(item, color: _color()),
      )));
    }
    if (item.location != null && item.location.isNotEmpty) {

      controls.add(Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: RoundedButton(
            onPressed: () {
              MapsLauncher.launchQuery(item.location);
            },
            label: 'Показать на карте',
            icon: FontAwesomeIcons.mapMarker,
            color: _color(),
          ),
        ),
      ));
    }
    if (item.link != null) {
      controls.add(Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: RoundedButton(
            onPressed: () {
              launch(item.link);
            },
            label: 'Перейти по ссылке',
            icon: FontAwesomeIcons.globe,
            color: _color(),
          ),
        ),
      ));
    }
    return controls;
  }

  Widget _vertical(context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color(0xffd6d7dB),
                offset: Offset(0, 0),
                spreadRadius: 0,
                blurRadius: 2)
          ]),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: ActivityLabel(
                        item.type,
                        color: _color(),
                      ),
                    ),
                    ActivityDate(item.dateTime, item.type, color: _color()),
//              ActivityIcon(item.type)
                  ],
                ),
                Container(
                  child: Text(
                    item.theme,
                    style: TextStyle(
                        fontSize: FontSize.h1(), fontWeight: FontWeight.w700),
                  ),
                  margin: EdgeInsets.only(bottom: 5),
                ),
                item.location != null && item.location.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Место',
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF8F9398),
                                height: 1.25),
                          ),
                          Container(
                            child: Text(
                              item.location,
                              style: TextStyle(fontSize: 16.0, height: 1.25),
                            ),
                            margin: EdgeInsets.only(top: 4, bottom: 4),
                          ),
                        ],
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: this._controls(),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _color().withOpacity(0.3),
              borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10)),
            ),
            child: Material(
              type: MaterialType.transparency,
              elevation: 6.0,
              color: Colors.transparent,
              shadowColor: Colors.grey[50],
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SingleActivityScreen(item)));
//              Scaffold.of(context).showSnackBar(SnackBar(
//                content: Text('Tap'),
//              ));
                },
                child: SizedBox(
                  height: 32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Подробнее',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            height: 1.25,
                            color: _color()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _confirmationItem(context) {
    List<Widget> children = [
      Container(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 56,
                  width: 56,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        Provider.of<RoomMemberRepository>(context,
                                listen: false)
                            .getMember(Provider.of<NetworkService>(context, listen: false)
                                .user
                                .studentId)
                            .avatar),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Provider.of<RoomMemberRepository>(context, listen: false)
                        .getMember(Provider.of<NetworkService>(context, listen: false)
                            .user
                            .studentId)
                        .fullName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Предлагает встречу',
                      style: const TextStyle(
                          fontSize: 16, color: const Color(0xFF8F9398)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      new DateFormat('dd MMMM y г. HH:mm', 'ru')
                          .format(item.dateTime),
                      style: const TextStyle(
                          fontSize: 16, color: const Color(0xFF1184ED)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      item.theme,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: ConfirmationDescription(item.description),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ];
    if (item.dateTime.isBefore(new DateTime.now())) {
      children.add(_confirmationButton(
          Text('Предложить другую дату',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1184ED))), () {
        _selectAnotherDate(context);
      }));
    } else {
      children.add(_confirmationButton(
          Text(
            'Принять',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1184ED)),
          ), () async {
        var newStatus = await Provider.of<Activities>(context, listen: false)
            .updateActivityStatus(item, ActivityStatus.in_progress);
        if (newStatus == ActivityStatus.in_progress) {
          Provider.of<ChatBLoC>(context, listen: false).sendMessageToPair(
              'Автосообщение: Встреча "${item.theme}", предложенная на ${new DateFormat('dd.MM.y').format(item.dateTime.toLocal())}, согласована.');
        }
      }));
      children.add(_confirmationButton(
          Text('Изменить дату',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1184ED))), () {
        _selectAnotherDate(context);
      }));
    }

    children.add(ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10.0)),
        child: _confirmationButton(
            Text('Отклонить',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFEF627D))), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RejectMeetingScreen(item)));
//                    showDialog(
//                      context: context,
//                      builder: (BuildContext context) {
//                        // return object of type Dialog
//                        return _rejectMeetingAlert(context);
//                      },
//                    );
        })));

    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC7C7C7)),
      ),
      child: Column(children: children),
    );
  }

  Future _selectAnotherDate(context) async {
    var now = new DateTime.now().subtract(Duration(days: 1));
    var date = await DateInput.openChangeTimeDialog(
      context,
      minimumDate: now,
      maximumDate: new DateTime(now.year + 1, now.month, now.day),
      date: item.dateTime,
    );
    if (date != null) {
      var oldDate = item.dateTime;
      var newStatus = await Provider.of<Activities>(context, listen: false)
          .updateActivityStatus(item, ActivityStatus.in_progress,
              datetime: date);
      if (newStatus == ActivityStatus.in_progress) {
        var oldDateStr = new DateFormat('dd.MM.y').format(oldDate.toLocal());
        var newDateStr = new DateFormat('dd.MM.y HH:mm').format(date.toLocal());
        Provider.of<ChatBLoC>(context, listen: false).sendMessageToPair(
            'Автосообщение: Встреча "${item.theme}", предложенная на $oldDateStr, перенесена на $newDateStr.');
      }
    }
  }

  Widget _rejectMeetingAlert(context) {
    return AlertDialog(
      title: new Text("Отказаться от встречи"),
      content:
          new Text("Это действие необратимо, вы действительно этого хотите?"),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Принять"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text("Изменить дату"),
          onPressed: () {
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

  Widget _confirmationButton(Text text, Function onTap) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Color(0xFFE4E6E5)),
            ),
          ),
          child: Center(
            child: text,
          ),
        ),
      ),
    );
  }

  Widget _horizontal(context) {
    var _bottom = <Widget>[];

    if (item.location != null && item.location.isNotEmpty) {
      _bottom.add(Container(
        padding: EdgeInsets.only(left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Место',
              style: TextStyle(
                  fontSize: 12.0, color: Color(0xFF8F9398), height: 1.25),
            ),
            Container(
              child: Text(
                item.location,
                style: TextStyle(fontSize: 16.0, height: 1.25),
              ),
              margin: EdgeInsets.only(top: 4),
            ),
          ],
        ),
      ));
      _bottom.add(Container(
        padding: EdgeInsets.only(left: 12, right: 12),
        child: RoundedButton(
          onPressed: () {
            MapsLauncher.launchQuery(item.location);
          },
          label: 'Показать на карте',
          icon: FontAwesomeIcons.mapMarker,
          color: ActivityAttribute.attributeOf(item.type).color,
        ),
      ));
    }
    if (item.link != null && item.link.isNotEmpty) {
      _bottom.add(Container(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: RoundedButton(
            onPressed: () {
              launch(item.link);
            },
            label: 'Перейти по ссылке',
            icon: FontAwesomeIcons.globe,
            color: ActivityAttribute.attributeOf(item.type).color,
          )));
    }
    if (item.dateTime != null && item.status == ActivityStatus.in_progress) {
      _bottom.add(Container(
        padding: EdgeInsets.only(left: 12, right: 12),
        child: Consumer<Activity>(builder: (context, activity, child) {
          return ActivityCalendarButton(activity);
        }),
      ));
    }

    _bottom.add(Container(
      margin: EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: ActivityAttribute.attributeOf(item.type).opacityColor,
        borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10)),
      ),
      child: Material(
        type: MaterialType.transparency,
        elevation: 6.0,
        color: Colors.transparent,
        shadowColor: Colors.grey[50],
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleActivityScreen(item)));
//              Scaffold.of(context).showSnackBar(SnackBar(
//                content: Text('Tap'),
//              ));
          },
          child: SizedBox(
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Подробнее',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 1.25,
                      color: ActivityAttribute.attributeOf(item.type)
                          .opacityColor),
                ),
              ],
            ),
          ),
        ),
      ),
    ));

    return Container(
      width: 171,
      decoration: BoxDecoration(
          color: Color(0xffF6F7FB),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color(0xffd6d7dB),
                offset: Offset(0, 0),
                spreadRadius: 0,
                blurRadius: 2)
          ]),
      margin: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ActivityLabel(item.type),
//                ActivityIcon(item.type),
                  ],
                ),
                ActivityDate(item.dateTime, item.type),
                Container(
                  child: Text(
                    item.theme,
                    style: TextStyle(
                        fontSize: 16.0,
                        height: 1.5,
                        fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: EdgeInsets.only(bottom: 5),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _bottom,
          )
        ],
      ),
    );
  }

  Widget _loading() {
    return Container(
      width: 170,
      decoration: BoxDecoration(
          color: Color(0xffF6F7FB),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color(0xffd6d7dB),
                offset: Offset(0, 0),
                spreadRadius: 0,
                blurRadius: 2)
          ]),
      margin: EdgeInsets.only(left: 8, right: 8),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(child: Text('Загрузка события...')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (item.isLoading) {
      this._loading();
    }
    if (item.type == ActivityType.meeting &&
        item.status == ActivityStatus.confirmation &&
        (item as Meeting).isLeader) {
      return _confirmationItem(context);
    }
    return axis == Axis.vertical
        ? this._vertical(context)
        : this._horizontal(context);
  }
}
