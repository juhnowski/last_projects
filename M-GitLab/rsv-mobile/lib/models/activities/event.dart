import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/activities/event_status.dart';
import 'package:device_calendar/device_calendar.dart' as Calendar;

class Event extends ChangeNotifier implements Activity {
  final int id;
  final ActivityType type;
  String theme;
  String description;
  String location;
  String link;

  bool _hasCalendarEvent;
  bool get hasCalendarEvent => _hasCalendarEvent;
  set hasCalendarEvent(bool v) {
    _hasCalendarEvent = v;
    notifyListeners();
  }

  Calendar.Event _calendarEvent;
  Calendar.Event get calendarEvent => _calendarEvent;
  set calendarEvent(Calendar.Event v) {
    _hasCalendarEvent = v != null;
    _calendarEvent = v;
    notifyListeners();
  }

  bool isLoading = true;
  DateTime dateTime;
  int foreignEventId;
  ActivityStatus get status => _status;
  set status(ActivityStatus status) {
    _status = status;
    notifyListeners();
  }

  ActivityStatus _status;

  Event(
    this.id, {
    @required this.type,
    @required this.foreignEventId,
    @required ActivityStatus status,
    this.theme,
    this.description,
    this.dateTime,
    this.location,
    this.isLoading = true,
  }) {
    _status = status;
  }

  static Event fromJson(Map<String, Object> json) {

    return Event(
      json['id'] as int,
      type: _getEventType(json['type'] as String),
      foreignEventId: json['foreignEventId'] as int,
      status: EventStatus.stringToActivityStatus(json['status'] as String),
    );
  }

  setCmsContent(Map<String, Object> json) {
    theme = json['theme'];
    description = json['description'];
    dateTime =
        DateTime.fromMillisecondsSinceEpoch((json['datetime'] as int) * 1000)
            .toLocal();
    location = json['location'];
    isLoading = false;

    if (type == ActivityType.webinar) {
      link = 'https://lms.rsv.ru/webinars/${json['foreignWebinarId']}/page';

    }

    if (type == ActivityType.course) {
      link = 'https://lms.rsv.ru/courses/${json['foreignCourseId']}/page';
    }

    notifyListeners();
  }

  static ActivityType _getEventType(String name) {
    ActivityType type;
    switch (name) {
      case 'webinar':
        type = ActivityType.webinar;
        break;
      case 'session':
        type = ActivityType.session;
        break;
      case 'course':
        type = ActivityType.course;
        break;
    }
    if (type == null) {
      throw Exception('Unable to indentify Event activity type;');
    }
    return type;
  }
}
