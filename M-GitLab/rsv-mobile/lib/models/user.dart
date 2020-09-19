import 'package:flutter/foundation.dart';
import 'package:rsv_mobile/models/group.dart';
import 'package:rsv_mobile/services/network.dart';

class User extends ChangeNotifier {
  Group _group = new Group();
  int _userId;
  Map _info;
  String _avatarUrl;

  int get userId => _userId;
  bool get isLoggedIn => _userId != null;
  Map get info => _info;
  Group get group => _group;
  int get groupId => _group.id;
  int get leaderId => _group.leaderId;
  int get studentId => _group.studentId;
  int get curatorId => _group.curatorId;
  bool get isLeader => _userId == _group.leaderId;
  bool get isStudent => _userId == _group.studentId;
  String get avatar => _avatarUrl;

  loadUser(NetworkService network, int userId) async {
    _userId = userId;
    if (_userId == null) {
      return;
    }

    Map userProfile;
    userProfile = (await network.profileInfo(_userId))['info'];
    // Check on membership in mentoring program
    // TODO: add check on leader program participation
    // if (userProfile['isLeader'] != true) {
    //   network.authLogout();
    //   throw 'Вы не являетесь участником программы. Пожайлуйста обратитесь в поддержку';
    // }
    print(userProfile);
    if (userProfile['info'] is Map) {
      _avatarUrl = userProfile['info']['userImage'];
    }
    Map userGroups = await network.userGroups(_userId);

    if (userGroups['groups'].isEmpty) {
      await network.authLogout();
      throw 'Вы не прикреплены к группе. Пожалуйста обратитесь в поддержку';
    }
    var groupInfo = userGroups['groups'][0];

    _group = new Group();
    await _group.loadGroup(network, _userId, groupInfo['id']);
    notifyListeners();
  }
}
