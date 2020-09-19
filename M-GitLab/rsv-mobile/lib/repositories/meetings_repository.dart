import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/activities/meeting.dart';
import 'package:rsv_mobile/models/activities/meeting_status.dart';
import 'package:rsv_mobile/services/network.dart';


class MeetingsRepository {
  NetworkService _networkService;

  MeetingsRepository(this._networkService);

  create(
      {int groupId,
      String name,
      String description,
      DateTime date,
      String location}) async {
    await _networkService.createMeeting({
      'theme': name,
      'description': description,
      'group_id': groupId,
      'datetime': date.toUtc().toIso8601String(),
      'location': location,
    });
  }

  Future<List<Meeting>> load(int groupId, bool isLeader) async {
    Map data = await _networkService.getMeetings(groupId);
    print(data);
    return (data['meetings'] as List)
        .map<Meeting>((v) => Meeting.fromJson(v, isLeader))
        .toList();
  }

  Future<ActivityStatus> updateStatus(Meeting meeting, ActivityStatus status,
      {DateTime datetime}) async {
    if (!meeting.isLeader) {
      throw Exception('Only Leader can change meeting status');
    }
    var statusString = MeetingStatus.activityStatusToString(status);
    if (status != ActivityStatus.in_progress &&
        status != ActivityStatus.rejected) {
      throw Exception(
          'Unable to change activity status to $statusString by user request');
    }
    var update = {
      'meeting_id': meeting.id,
      'status': statusString,
    };
    if (datetime != null) {
      update['datetime'] = datetime.toUtc().toIso8601String();
    }
    try {
      await _networkService.updateMeeting(update);
    } catch (e) {
      print('Unable to update event status: network error');
    }
    if (update['datetime'] != null) {
      meeting.dateTime = datetime.toLocal();
    }
    meeting.status = status;
    return meeting.status;
  }

  Future<ActivityStatus> rate(Meeting meeting, int rating) async {
    if (!meeting.canRate) {
      throw Exception('Unable to change meeting rating');
    }
    try {
      await _networkService.rateMeeting({
        'meeting_id': meeting.id,
        'rating': rating,
      });
    } catch (e) {
      print('Unable to update event status: network error');
    }
    meeting.rate(rating);
    return meeting.status;
  }

  Future<ActivityStatus> reject(Meeting meeting, String reason) async {
    if (meeting.status != ActivityStatus.confirmation) {
      throw Exception('Unable to reject meeting');
    }
    try {
      await _networkService.rejectMeeting({
        'meeting_id': meeting.id,
        'rejection_reason': reason,
      });
    } catch (e) {
      print('Unable to update event status: network error');
    }
    meeting.status = ActivityStatus.rejected;
    return meeting.status;
  }
}
