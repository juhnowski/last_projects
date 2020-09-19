import 'package:rsv_mobile/utils/time.dart';

class RoomMember {
  int userId;
  String userName;
  String userSurname;
  String avatar;
  bool isOnline = false;
  DateTime lastOnline;
  bool isMe = false;
  bool isLeader = false;
  bool isStudent = false;

  bool get isLoaded => userName != null;
  String get fullName => '$userName $userSurname';
  String get lastOnlineText {
    if (isOnline) {
      return 'В сети';
    } else if (lastOnline != null) {
      return 'Был(а) в сети ${TimeUtils.getFormattedLastMessageTime(lastOnline).toLowerCase()}';
    } else {
      return 'Не в сети';
    }
  }

  RoomMember(
    this.userId, {
    this.isMe = false,
//        this.userName,
//        this.userSurname,
//        this.avatar,
//        this.lastOnline,
  });
}
