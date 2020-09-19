import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/activities/meeting.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/repositories/tasks_repository.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rsv_mobile/widgets/UI/rounded_button.dart';
import 'package:rsv_mobile/widgets/activities/calendar_button.dart';
import 'package:rsv_mobile/widgets/activities/date.dart';
import 'package:rsv_mobile/widgets/activities/label.dart';
import 'package:rsv_mobile/widgets/activities/tasks.dart';
import 'package:rsv_mobile/widgets/home/custom_button.dart';
import 'package:rsv_mobile/widgets/meeting/meeting_rate.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityDetails extends StatefulWidget {
  final Activity item;

  ActivityDetails({this.item});

  @override
  _ActivityDetailsState createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  bool showStatusPicker = false;
  bool canSelectStatus = false;
  bool savingStatus = false;

  bool showRatingPicker = false;
  bool canSelectRating = false;
  bool savingRating = false;

  @override
  void initState() {
    super.initState();
    _checkStatusPicker();
    _checkRatingPicker();
  }

  _checkStatusPicker() {
    if (widget.item.dateTime.isBefore(new DateTime.now())) {
      showStatusPicker = true;
      if (widget.item.status == ActivityStatus.in_progress) {
        canSelectStatus = true;
      }
    }
  }

  _checkRatingPicker() {
    if (widget.item.type == ActivityType.meeting) {
      Provider.of<TasksRepository>(context, listen: false)
          .setMeeting(widget.item.id);
      var meeting = widget.item as Meeting;
      if (meeting.canRate) {
        showRatingPicker = true;
        if (meeting.status == ActivityStatus.in_progress) {
          canSelectRating = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.item,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _cardItems(),
        ),
      ),
    );
  }

  List<Widget> _cardItems() {
    var items = _info();
    if (widget.item.location != null && widget.item.location.isNotEmpty) {
      items.add(_location());
    }

    if (widget.item.link != null) {
      items.add(_webLink());
    }

    if (widget.item.status == ActivityStatus.in_progress) {
      items.add(_calendarItem());
    }

    if (widget.item.type != ActivityType.meeting && showStatusPicker) {
      items.add(_statusPicker());
    }
    if (widget.item.type == ActivityType.meeting && showRatingPicker) {
      items.add(_tasks());
      items.add(_ratePicker());
    }
    return items;
  }

  List<Widget> _info() {
    return <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ActivityLabel(widget.item.type),
          ),
          ActivityDate(widget.item.dateTime, widget.item.type),
//              ActivityIcon(item.type)
        ],
      ),
      Container(
        child: Text(
          widget.item.theme,
          style:
              TextStyle(fontSize: FontSize.h1(), fontWeight: FontWeight.w700),
        ),
        margin: EdgeInsets.only(bottom: 16),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Описание',
              style: TextStyle(
                  fontSize: FontSize.body(), color: Color(0xFF8F9398)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.item.description,
              style: TextStyle(fontSize: 16.0, height: 1.25),
            ),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Контакты',
              style: TextStyle(
                  fontSize: FontSize.body(), color: Color(0xFF8F9398)),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Сергей Коляда',
                    style: TextStyle(
                        fontSize: FontSize.subtitle(),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Руководитель пресс-службы АНО «Россия – страна возможностей»',
                    style: TextStyle(fontSize: FontSize.subtitle()),
                  ),
                ),
                new RichText(
                    text: new TextSpan(
                  text: '+7 (987) 321-21-31',
                  style: new TextStyle(
                      color: Colors.blue,
                      fontSize: FontSize.subtitle(),
                      height: 2),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      launch('tel:+79873212131');
                    },
                )),
                new RichText(
                    text: new TextSpan(
                  text: 'rsv@mail.ru',
                  style: new TextStyle(
                      color: Colors.blue,
                      fontSize: FontSize.subtitle(),
                      height: 2),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      launch('mailto:rsv@mail.ru');
                    },
                )),
              ])
        ],
      )
    ];
  }

  Widget _webLink() {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: RoundedButton(
        onPressed: () {
          launch(widget.item.link);
        },
        label: 'Перейти по ссылке',
        icon: FontAwesomeIcons.globe,
        color: ActivityAttribute.attributeOf(widget.item.type).color,
      ),
    );
  }

  Widget _location() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Место',
            style: TextStyle(
                fontSize: FontSize.body(),
                color: Color(0xFF8F9398),
                height: 1.25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            widget.item.location,
            style: TextStyle(
                fontSize: FontSize.subtitle(), fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 8),
          child: RoundedButton(
            onPressed: () {
              MapsLauncher.launchQuery(widget.item.location);
            },
            label: 'Показать на карте',
            icon: FontAwesomeIcons.mapMarker,
            color: ActivityAttribute.attributeOf(widget.item.type).color,
          ),
        )
      ],
    );
  }

  Widget _calendarItem() {
    return Container(
      margin: EdgeInsets.only(top: 32),
      height: 115,
      decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Color(0xffd6d7dB),
                offset: Offset(0, 0),
                spreadRadius: 0,
                blurRadius: 2)
          ]),
      child: Container(
          constraints: BoxConstraints.expand(),
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Событие в календаре устройства',
                  style: TextStyle(
                      fontSize: FontSize.body(),
                      color: Color(0xFF8F9398),
                      height: 1.25),
                ),
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.center,
//                      child: ActivityCalendarButton(widget.item),
                child: Consumer<Activity>(
                    builder: (context, activity, child) =>
                        ActivityCalendarButton(activity)),
              ))
            ],
          )),
    );
  }

  Widget _statusPicker() {
    return Container(
        padding: EdgeInsets.only(top: 32),
        child: savingStatus
            ? Center(child: CircularProgressIndicator())
            : canSelectStatus
                ? Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButton(
                            text: 'Посетил(-а)',
                            onPressed: () async {
                              setState(() {
                                savingStatus = true;
                              });
                              var newStatus = await Provider.of<Activities>(
                                      context,
                                      listen: false)
                                  .updateActivityStatus(
                                      widget.item, ActivityStatus.completed);
                              setState(() {
                                if (newStatus != null) {
                                  canSelectStatus = !canSelectStatus;
                                }
                                savingStatus = false;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButton(
                            text: 'Пропустил(-а)',
                            color: Color(0xFFD1004A),
                            onPressed: () async {
                              setState(() {
                                savingStatus = true;
                              });
                              var newStatus = await Provider.of<Activities>(
                                      context,
                                      listen: false)
                                  .updateActivityStatus(
                                      widget.item, ActivityStatus.missed);
                              setState(() {
                                if (newStatus != null) {
                                  canSelectStatus = !canSelectStatus;
                                }
                                savingStatus = false;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            widget.item.status == ActivityStatus.completed
                                ? 'Вы посетители данное мероприятие'
                                : 'Вы пропустили данное мероприятие',
                            style: TextStyle(
                                color: const Color(0xFF979797),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          child: RoundedButton(
                            label: 'Изменить решение',
                            color: const Color(0xFF979797),
                            onPressed: () {
                              setState(() {
                                canSelectStatus = !canSelectStatus;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ));
  }

  Widget _tasks() {
    return Consumer<Activity>(
        builder: (context, activity, child) =>
            (activity.status == ActivityStatus.completed)
                ? ActivityTasks(activity.id)
                : Container());
  }

  Widget _ratePicker() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 32),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
            color: Color(0xffFFFFFF),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Color(0xffd6d7dB),
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                  blurRadius: 2)
            ]),
        child: Consumer<Activity>(
            builder: (context, activity, child) =>
                RateMeeting.small(activity)));
  }
}
