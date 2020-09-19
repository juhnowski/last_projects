import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/services/calendars_manager.dart';
import 'package:rsv_mobile/widgets/UI/rounded_button.dart';

class ActivityCalendarButton extends StatefulWidget {
  final Activity item;
  final Color color;

  ActivityCalendarButton(this.item, {this.color});

  @override
  _ActivityCalendarButtonState createState() => _ActivityCalendarButtonState();
}

class _ActivityCalendarButtonState extends State<ActivityCalendarButton> {
  bool addingToCalendar = false;
  bool get isLoading =>
      addingToCalendar || widget.item.hasCalendarEvent == null;

  bool get hasCalendarEvent =>
      widget.item.hasCalendarEvent != null && widget.item.hasCalendarEvent;

  @override
  Widget build(BuildContext context) {
    var color = hasCalendarEvent
        ? Color(0xFF9F9f9f)
        : widget.color ?? ActivityAttribute.attributeOf(widget.item.type).color;
    return SizedBox(
      width: double.infinity,
      child: RoundedButton(
          onPressed: hasCalendarEvent
              ? null
              : () async {
                  setState(() {
                    addingToCalendar = true;
                  });
                  var calendarManager =
                      Provider.of<CalendarsManager>(context, listen: false);
                  if (calendarManager.activeCalendar == null) {
                    await _showCalendarPicker(context, calendarManager);
                  }
                  await Provider.of<Activities>(context, listen: false)
                      .addToCalendar(widget.item);
                  Future.delayed(Duration(milliseconds: 700), () {
                    setState(() {
                      addingToCalendar = false;
                    });
                  });
                },
          label: hasCalendarEvent ? 'Cобытие добавлено' : 'Добавить событие',
          icon: hasCalendarEvent
              ? FontAwesomeIcons.calendarCheck
              : FontAwesomeIcons.calendarPlus,
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeWidth: 2,
                  ))
              : null,
          color: color),
    );
  }

  _showCalendarPicker(BuildContext context, CalendarsManager calendarManager) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Выберите календарь'),
          children: calendarManager.calendars
              .map<Widget>((calendar) => Container(
                    height: 60,
                    child: SimpleDialogOption(
                      onPressed: () async {
                        var calendarId =
                            await calendarManager.setActiveCalendar(calendar);
                        Navigator.of(context).pop(calendarId);
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            calendar.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1184ED)),
                          )),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
