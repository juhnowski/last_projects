import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rsv_mobile/models/activities/meeting_status.dart';
import 'activity.dart';
import 'package:device_calendar/device_calendar.dart' as Calendar;

class Meeting extends ChangeNotifier implements Activity {
  final int id;
  final ActivityType type = ActivityType.meeting;
  bool isLoading;
  String theme;
  String description;
  String location;
  String link;
  DateTime dateTime;
  ActivityStatus get status => _status;
  set status(ActivityStatus status) {
    _setStatus(status);
    notifyListeners();
  }

  ActivityStatus _status;
  String rejectionReason;
  int studentRating;
  int leaderRating;
  DateTime createdAt;
  bool isLeader;
  bool canRate = false;
  int get rating => isLeader ? leaderRating : studentRating;

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

  Meeting(
    this.id, {
    @required this.dateTime,
    @required status,
    this.theme,
    this.description,
    this.location,
    this.rejectionReason,
    this.studentRating,
    this.leaderRating,
    this.isLoading = true,
    this.isLeader,
  }) {
    _setStatus(status);
  }

  _setStatus(ActivityStatus newStatus) {
    if (newStatus == ActivityStatus.rejected ||
        newStatus == ActivityStatus.confirmation) {
      _status = newStatus;
    } else {
      var userRating = rating;
      if (userRating == null) {
        _status = ActivityStatus.in_progress;
      } else if (userRating == 0) {
        _status = ActivityStatus.missed;
      } else {
        _status = ActivityStatus.completed;
      }
    }
    if ((_status == ActivityStatus.in_progress ||
            _status == ActivityStatus.missed ||
            _status == ActivityStatus.completed) &&
        dateTime.isBefore(new DateTime.now())) {
      canRate = true;
    }
  }

  rate(int rate) {
    assert(rate != null && rate >= 0 && rate <= 3);
    if (!canRate) {
      throw Exception('Unable to rate meeting $id');
    }
    if (isLeader) {
      leaderRating = rate;
    } else {
      studentRating = rate;
    }
    _setStatus(status);
    notifyListeners();
  }

  static Meeting fromJson(Map<String, Object> json, bool isLeader) {
    return Meeting(
      json['id'] as int,
//        dateTime: new DateTime.now().add(Duration(hours: 1)),
      dateTime: DateTime.parse(json['datetime']).toLocal(),
//      dateTime:
//          DateTime.fromMillisecondsSinceEpoch((json['datetime'] as int) * 1000)
//              .toLocal(),
      status: MeetingStatus.stringToActivityStatus(json['status'] as String),
      theme: json['theme'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      rejectionReason: json['rejectionReason'] as String,
      studentRating: json['ratingFromStudent'] as int,
      leaderRating: json['ratingFromLeader'] as int,
      isLoading: false,
      isLeader: isLeader,
    );
  }
}
