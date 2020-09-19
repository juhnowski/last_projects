import 'package:flutter/cupertino.dart';
import 'package:rsv_mobile/models/chat/chat_room_member.dart';
import 'package:rsv_mobile/services/network.dart';

class RoomMemberRepository extends ChangeNotifier {
  NetworkService _networkService;
  Map<int, ChatRoomMember> cachedMembers = {};
  int _userId;

  RoomMemberRepository();

  update(NetworkService networkService) {
    _networkService = networkService;
    userId = _networkService.userId;
    syncMembers(networkService.user?.group?.memberIds ?? []);
  }

  set userId(id) {
    var changed = false;
    if (id != null && id != _userId) {
      if (cachedMembers.containsKey(_userId)) {
        cachedMembers[_userId].isMe = false;
        changed = true;
      }
      _userId = id;
      if (cachedMembers.containsKey(_userId)) {
        cachedMembers[_userId].isMe = true;
        changed = true;
      } else {
        syncMembers([_userId]);
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  ChatRoomMember getMember(id) {
    if (cachedMembers.containsKey(id)) {
      return cachedMembers[id];
    } else {
      return ChatRoomMember(id, isMe: id == _userId);
    }
  }

  Future syncMembers(List<int> memberIds) async {
    List<ChatRoomMember> toFetch = [];
    memberIds.forEach((id) {
      if (!cachedMembers.containsKey(id)) {
        toFetch.add(ChatRoomMember(id, isMe: id == _userId));
      }
    });
    if (toFetch.length > 0) {
      (await fetchMembers(toFetch)).forEach((m) {
        cachedMembers[m.userId] = m;
      });
      notifyListeners();
    }
  }

  Future<Iterable<ChatRoomMember>> fetchMembers(
      Iterable<ChatRoomMember> members) async {
    Iterable<int> ids = members.map<int>((v) => v.userId);
    final users = await _networkService.getUsersBulk(ids);
    return members.map((member) {
      if (users[member.userId] == null) {
        member.isNotFound = true;
        return member;
      }
      member.isNotFound = false;
      member.userName = users[member.userId]['user_name'];
      member.userSurname = users[member.userId]['user_surname'];
      if (users.containsKey(member.userId) &&
          users[member.userId] is Map &&
          users[member.userId].containsKey('profile') &&
          users[member.userId]['profile'] is Map
      ) {
        member.setProfile(users[member.userId]['profile']);
      }
      return member;
    });
  }

  setUsersOnline(List<Map> users) {
    users.forEach((user) {
      if (cachedMembers.containsKey(user['user_id'])) {
        cachedMembers[user['user_id']].isOnline =
            true; //user['is_online'] == 1;
        cachedMembers[user['user_id']].lastOnline = user['last_online'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(user['last_online'] * 1000);
      }
    });
    notifyListeners();
  }

  clear() {
    cachedMembers?.clear();
    notifyListeners();
  }
}
