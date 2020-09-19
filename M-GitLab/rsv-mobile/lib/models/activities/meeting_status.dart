import 'package:rsv_mobile/models/activities/activity.dart';

class MeetingStatus {
  static String activityStatusToString(ActivityStatus type) {
    const Map<ActivityStatus, String> _info = {
      ActivityStatus.confirmation: 'as_agreed',
      ActivityStatus.in_progress: 'accepted',
      ActivityStatus.rejected: 'rejected',
      ActivityStatus.completed: 'completed',
      ActivityStatus.missed: 'missed',
    };
    var status = _info[type];
    assert(status != null);
    return status;
  }

  static ActivityStatus stringToActivityStatus(String name) {
    const Map<String, ActivityStatus> _info = {
      'as_agreed': ActivityStatus.confirmation,
      'accepted': ActivityStatus.in_progress,
      'rejected': ActivityStatus.rejected,
      'completed': ActivityStatus.completed,
      'missed': ActivityStatus.missed,
    };
    return _info[name] ?? null;
  }
}
