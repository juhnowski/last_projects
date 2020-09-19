import 'package:device_calendar/device_calendar.dart' as Calendar;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/activities/meeting.dart';
import 'package:rsv_mobile/repositories/events_repository.dart';
import 'package:rsv_mobile/repositories/meetings_repository.dart';
import 'package:rsv_mobile/models/user.dart';
import 'package:rsv_mobile/services/calendars_manager.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activities extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final CalendarsManager calendarsManager;
  final EventsRepository eventsRepository;
  final MeetingsRepository meetingsRepository;

  Activities({
    @required this.eventsRepository,
    @required this.meetingsRepository,
    @required this.calendarsManager,
  });

  int _groupId;
  int _userId;
  bool _isLeader;
  List<Activity> activities;

  set user(User user) {
    if (user.userId == null || user.groupId == null) {
      activities = [];
      _isLeader = false;
      _userId = null;
      _groupId = null;
      pushRateActivities();
      notifyListeners();
      return;
    }
    bool shouldLoad = false;
    if (_userId != user.userId) {
      _userId = user.userId;
      shouldLoad = true;
    }
    if (_groupId != user.groupId) {
      _groupId = user.groupId;
      _isLeader = user.group.leaderId == _userId;
      shouldLoad = true;
    }
    if (shouldLoad) {
      loadActivities();
    }
  }

  final _toRateStreamController = BehaviorSubject<Activity>();
  Stream<Activity> get rateActivities => _toRateStreamController.stream;

  @override
  void dispose() {
    _toRateStreamController.close();
    super.dispose();
  }

  pushRateActivities() async {
    var item = activities?.firstWhere(
        (activity) =>
            activity.type == ActivityType.meeting &&
            activity.status == ActivityStatus.in_progress &&
            activity.dateTime != null &&
            activity.dateTime.isBefore(new DateTime.now()) &&
            (activity as Meeting).canRate &&
            (activity as Meeting).rating == null,
        orElse: () => null);
    var last = _toRateStreamController.stream.value;
    if (last != null && item != null && item.id == last.id) {
      print('dont push to stream');
    } else {
      _toRateStreamController.add(item);
    }
  }

  List<Activity> get upcomingActivities =>
      activities
          ?.where((activity) =>
              activity.status == ActivityStatus.in_progress &&
              activity.dateTime != null &&
              activity.dateTime.isAfter(new DateTime.now()))
          ?.toList() ??
      [];
  List<Activity> get confirmationActivities =>
      activities
          ?.where((activity) => activity.status == ActivityStatus.confirmation)
          ?.toList() ??
      [];
  List<Activity> get currentActivities => activities
          ?.where((activity) => activity.status == ActivityStatus.in_progress)
          ?.toList() ??
      []
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  List<Activity> get doneActivities =>
      activities
          ?.where((activity) => activity.status == ActivityStatus.completed)
          ?.toList() ??
      [];
  List<Activity> get skippedActivities =>
      activities
          ?.where((activity) => activity.status == ActivityStatus.missed)
          ?.toList() ??
      [];

  Future<bool> createActivity(ActivityType type, String name,
      String description, DateTime date, String location,
      {int userId}) async {
    if (type == ActivityType.meeting) {
      await meetingsRepository.create(
          groupId: _groupId,
          date: date,
          name: name,
          description: description,
          location: location);
      return true;
    } else {
      throw Exception(
          'Unable to create activity with type: ${describeEnum(type)}');
    }
  }

  Future<ActivityStatus> updateActivityStatus(
      Activity activity, ActivityStatus status,
      {DateTime datetime}) async {
    var newStatus;
    if (activity.type == ActivityType.meeting) {
      newStatus = await meetingsRepository.updateStatus(activity, status,
          datetime: datetime);
    } else {
      newStatus = await eventsRepository.updateStatus(activity, status);
    }
    if (newStatus != null) {
      notifyListeners();
    }
    return newStatus;
  }

  Future<ActivityStatus> rateActivity(Activity activity, int rating) async {
    if (activity.type != ActivityType.meeting) {
      throw Exception('Unable to rate ${describeEnum(activity.type)}');
    }
    var status = await meetingsRepository.rate(activity, rating);
    if (status != null) {
      pushRateActivities();
      notifyListeners();
    }
    return status;
  }

  Future<ActivityStatus> rejectActivity(
      Activity activity, String reason) async {
    if (activity.type != ActivityType.meeting) {
      throw Exception('Unable to reject ${describeEnum(activity.type)}');
    }
    var status = await meetingsRepository.reject(activity, reason);
    if (status != null) {
      notifyListeners();
    }
    return status;
  }

  Future<Calendar.Event> loadCalendarEvent(Activity activity) async {
    final SharedPreferences prefs = await _prefs;
    var eventId = prefs
        .getString('calendar_${describeEnum(activity.type)}_${activity.id}');
    if (eventId == null) {
      return null;
    } else {
      var event = await calendarsManager.loadEvent(eventId);
      if (event == null) {
        await prefs
            .remove('calendar_${describeEnum(activity.type)}_${activity.id}');
      }
      return event;
    }
  }

  loadActivities() async {
    print('load activities');
    var res = await Future.wait([
      meetingsRepository.load(_groupId, _isLeader),
      eventsRepository.load(_groupId)
    ]);
    activities = [...res[0].cast<Activity>(), ...res[1].cast<Activity>()]
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    activities = await Future.wait(activities.map<Future<Activity>>((v) async {
      var event = await loadCalendarEvent(v);
      print('loaded event: $event');
      if (event == null) {
        v.hasCalendarEvent = false;
      } else {
        v.calendarEvent = event;
      }
      return v;
    }));

    pushRateActivities();
    notifyListeners();
  }

  Future<Activity> addToCalendar(Activity activity) async {
    if (activity.hasCalendarEvent) {
      throw Exception('Unable to add, event already added');
    }
    var event = await calendarsManager.createEvent(
        activity.theme, activity.dateTime,
        description: activity.description);
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(
        'calendar_${describeEnum(activity.type)}_${activity.id}',
        event.eventId);
    activity.calendarEvent = event;
    notifyListeners();
    return activity;
  }
}
