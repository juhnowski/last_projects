library activity;

import 'package:device_calendar/device_calendar.dart' as Calendar;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

part 'activity_type.dart';

enum ActivityStatus {
  confirmation,
  in_progress,
  completed,
  missed,
  rejected,
}

class Activity extends ChangeNotifier {
  final int id;
  final ActivityType type;
  bool isLoading;
  String theme;
  String description;
  DateTime dateTime;
  ActivityStatus status;
  String location;
  String link;
  bool hasCalendarEvent;
  Calendar.Event calendarEvent;
//    String link;
//    String contacts;

  Activity(this.id, {@required this.type});
}
