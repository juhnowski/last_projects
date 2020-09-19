import 'dart:collection';
import 'dart:math';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarsManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _permissionReady = false;
  UnmodifiableListView<Calendar> calendars;
  Calendar activeCalendar;
  DeviceCalendarPlugin _deviceCalendarPlugin;

  CalendarsManager() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
    loadActiveCalendar();
  }

  loadActiveCalendar() async {
    if (!_permissionReady) {
      _permissionReady = await _checkPermission();
    }

    print('prepare calendars ${_permissionReady}');
    if (_permissionReady) {
      await _loadCalendars();
      final SharedPreferences prefs = await _prefs;
      final calendarId = prefs.getString('active_calendar_id');
      activeCalendar =
          calendars.firstWhere((v) => v.id == calendarId, orElse: () => null);
    }
  }

  Future<String> setActiveCalendar(Calendar calendar) async {
    if (calendar == null) {
      throw Exception('Unable to set active calendar to null');
    }
    activeCalendar = calendar;
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('active_calendar_id', calendar.id);
    return calendar.id;
  }

  Future<Event> loadEvent(String id) async {
    var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
        activeCalendar.id, RetrieveEventsParams(eventIds: [id]));
    var items = calendarEventsResult?.data;
    return items == null || items.isEmpty ? null : items.first;
  }

  Future<Event> createEvent(String title, DateTime startDate,
      {DateTime endDate, String description}) async {
    if (endDate == null) {
      endDate = startDate.add(Duration(hours: 1));
    }
    var event = Event(activeCalendar.id,
        title: title, description: description, start: startDate, end: endDate);
    var res = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    var eventId = res?.data;
    event.eventId = eventId;
    return event;
  }

  Future<bool> _checkPermission() async {
    try {
      var permissionGranted = await _deviceCalendarPlugin.hasPermissions();
      if (!permissionGranted.isSuccess && !permissionGranted.data) {
        permissionGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionGranted.isSuccess || !permissionGranted.data) {
          return false;
        }
      }
      return true;
    } on PlatformException catch (e) {
      print(e);
    }
    return false;
  }

  _loadCalendars() async {
    calendars = (await _deviceCalendarPlugin.retrieveCalendars())?.data;
    print('calendars loaded ${calendars}');
  }
}
