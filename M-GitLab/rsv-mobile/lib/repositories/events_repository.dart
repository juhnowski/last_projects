import 'package:flutter/foundation.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/activities/event.dart';
import 'package:rsv_mobile/models/activities/event_status.dart';
import 'package:rsv_mobile/services/network.dart';

class EventsRepository {
  NetworkService _networkService;

  EventsRepository(this._networkService);

  Future<ActivityStatus> updateStatus(
      Event event, ActivityStatus status) async {
    var statusString = EventStatus.activityStatusToString(status);
    if (statusString == null) {
      return null;
    }
    try {
      await _networkService.setEventStatus(event.id, statusString);
      event.status = status;
    } catch (e) {
      print('Unable to update event status: network error');
      return null;
    }
    return event.status;
  }

  Future<List<Event>> load(int _groupId) async {
    List<Event> items;

    List events = (await _networkService.getEvents(_groupId))['events'];
    items = events.map<Event>((v) => Event.fromJson(v)).toList();

    Map<ActivityType, List<int>> toLoad = {};
    items.forEach((v) {
      if (!toLoad.containsKey(v.type)) {
        toLoad[v.type] = [v.foreignEventId];
      } else {
        toLoad[v.type].add(v.foreignEventId);
      }
    });
    Map<ActivityType, Map<int, Map>> cmsEntities = {};
    await Future.forEach(toLoad.keys, (type) async {
      Map items = await _networkService.getCmsEntities(
          describeEnum(type), toLoad[type]);
      cmsEntities[type] = Map.fromIterable(
        items['list'],
        key: (v) => v['id'],
        value: (v) => v,
      );
    });
    items.forEach((activity) {
      activity
          .setCmsContent(cmsEntities[activity.type][activity.foreignEventId]);
    });
    items.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return items;
  }
}
