import 'package:rsv_mobile/models/activities/activity.dart';

class EventStatus {
  static String activityStatusToString(ActivityStatus type) {
    const Map<ActivityStatus, String> _info = {
      ActivityStatus.confirmation: null,
      ActivityStatus.in_progress: null,
      ActivityStatus.completed: 'done',
      ActivityStatus.missed: 'skipped',
      ActivityStatus.rejected: null,
    };
    return _info[type];
  }

  static ActivityStatus stringToActivityStatus(String name) {
    const Map<String, ActivityStatus> _info = {
      'done': ActivityStatus.completed,
      'skipped': ActivityStatus.missed,
    };
    return _info[name] ?? ActivityStatus.in_progress;
  }
}
