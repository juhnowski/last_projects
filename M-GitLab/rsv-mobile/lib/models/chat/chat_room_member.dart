import 'package:rsv_mobile/services/network.dart';
import 'package:rsv_mobile/utils/time.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatRoomMember {
  int userId;
  String userName;
  String userSurname;
  String avatar;
  bool isOnline = false;
  DateTime lastOnline;
  bool isMe = false;
  bool isLeader = false;
  bool isStudent = false;
  bool isNotFound = false;
  Map _profileInfo;

  String city;
  String location;
  List<dynamic> activity;
  String about;
  DateTime dateOfBirth;
  String get age {
    if (dateOfBirth == null) return null;
    var currentDate = new DateTime.now();
    int age = currentDate.year - dateOfBirth.year;
    if (dateOfBirth.month > currentDate.month) {
        age--;
    } else if (dateOfBirth.month == currentDate.month && dateOfBirth.day > currentDate.day) {
        age--;
    }
    var unit = age % 10;
    if (age > 10 && age < 21 || (unit == 0 || unit >= 5)) {
      return '$age лет';
    } else {
      if (unit == 1) {
        return '$age год';
      } else {
        return '$age года';
      }
    }
  }
  String education;

  bool get isLoaded => isNotFound ? true : userName != null;
  String get fullName => '$userName $userSurname';

  String socialFb;
  String socialIg;
  String socialOk;
  String socialVk;
  String socialYt;

  String get lastOnlineText {
    if (isOnline) {
      return 'В сети';
    } else if (lastOnline != null) {
      return 'Был(а) в сети ${TimeUtils.getFormattedLastMessageTime(lastOnline).toLowerCase()}';
    } else {
      return 'Не в сети';
    }
  }

  get profileInfo => _profileInfo;

  setProfile(Map profile) {
    avatar = (profile['avatar'] is Map) ? profile['avatar']['url'] : null;
    dateOfBirth = profile['dateOfBirth'] == null ? null : DateTime.parse(profile['dateOfBirth']).toUtc();
    about = profile['about'];
    activity = profile['activity'];
    var locationMap = profile['address'];
    if (locationMap is Map) {
      if (locationMap.containsKey('data') && locationMap['data'] is Map) {
        if (locationMap['data'].containsKey('city_with_type')) {
          city = locationMap['data']['city_with_type'];
        } else if (locationMap['data'].containsKey('settlement_with_type')) {
          city = locationMap['data']['city_with_type'];
        }
      }
      if (locationMap.containsKey('value') && locationMap['value'] is String) {
        location = locationMap['value'];
      }
    }
    _updateSocialLinks(profile);
  }

//  _loadEducation(NetworkService networkService) async {
////    '${_profileInfo['firstEdu']['organization']}, ${_profileInfo['firstEdu']['specialty']}'
//    var data = await networkService.profileEducation(userId);
//    if (data is Map && data['education'] is List) {
//      var education = (data['education'] as List)..sort((a, b) => b['dateStart'] - a['dateStart']);
//      education.first
//    }
//  }

  _updateSocialLinks(Map profile) async {
    socialFb =
        (await canLaunch(profile['fb'])) ? profile['fb'] : null;
    socialIg =
        (await canLaunch(profile['instagram'])) ? profile['instagram'] : null;
    socialOk =
        (await canLaunch(profile['ok'])) ? profile['ok'] : null;
    socialVk =
        (await canLaunch(profile['vk'])) ? profile['vk'] : null;
    socialYt =
        (await canLaunch(profile['yt'])) ? profile['yt'] : null;
  }

  ChatRoomMember(
    this.userId, {
    this.isMe = false,
//        this.userName,
//        this.userSurname,
//        this.avatar,
//        this.lastOnline,
  });
}
