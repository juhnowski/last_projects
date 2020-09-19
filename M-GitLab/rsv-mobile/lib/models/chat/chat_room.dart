import 'package:flutter/cupertino.dart';
import 'package:rsv_mobile/models/chat/chat_room_message.dart';
import 'package:rsv_mobile/utils/time.dart';

class ChatRoom extends ChangeNotifier {
  String id;
  String image;
  String name;
  String _lastMessageText;
  DateTime lastMessageTime;
  int newMessagesCount = 0;
  List<int> members;

  bool _isLeader = false;
  bool _isStudent = false;
  bool _isCurator = false;
  int _currentUserId;

  String get lastMessageTimeFormatted =>
      TimeUtils.getFormattedLastMessageTime(lastMessageTime);

  bool get isLeader => _isLeader;
  checkLeader(int leaderId) {
    _isLeader = isPersonal && members.contains(leaderId);
  }

  bool get isStudent => _isStudent;
  checkStudent(int studentId) {
    _isStudent = isPersonal && members.contains(studentId);
  }

  bool get isCurator => _isCurator;
  checkCurator(int curatorId) {
    _isCurator = isPersonal && members.contains(curatorId);
  }

  int get personId {
    int personId;
    if (isPersonal) {
      print('_currentUserId  personId $_currentUserId');
      personId = members.firstWhere((v) => v != _currentUserId);
    }
    return personId;
  }

  updateMembership(
      {int leaderId, int studentId, int curatorId, int currentUserId}) {
    bool shouldNotify = false;
    if (leaderId != null && leaderId != currentUserId) {
      checkLeader(leaderId);
      shouldNotify = true;
    }
    if (studentId != null && studentId != currentUserId) {
      checkStudent(studentId);
      shouldNotify = true;
    }
    if (curatorId != null && curatorId != currentUserId) {
      checkCurator(curatorId);
      shouldNotify = true;
    }
    if (_currentUserId != currentUserId) {
      _currentUserId = currentUserId;
    }
    if (shouldNotify) {
      notifyListeners();
    }
  }

  String get lastMessageText => _lastMessageText ?? '';
  set lastMessageText(String text) {
    _lastMessageText = text;
  }

  int get membersCount => members.length;
  bool get isOnline => false;

  bool get isGroup => members.length > 2;
  bool get isPersonal => members.length == 2;
  bool get isEmpty => members.isEmpty;

  ChatRoom({
    @required this.id,
    @required this.members,
    @required this.name,
    this.image,
    String lastMessageText,
    this.lastMessageTime,
    this.newMessagesCount = 0,
  }) {
    _lastMessageText = lastMessageText;
  }

  setMessages(List<ChatRoomMessage> allMessages) {
    // TODO: REMOVE
//    messages = allMessages;
//    lastMessageText = messages.first.text;
//    lastMessageTime = messages.first.createdAt;
  }

  addMessage(ChatRoomMessage message, {bool isMine = false}) {
    lastMessageText = message.text;
    lastMessageTime = message.createdAt;
    if (!isMine) {
      newMessagesCount++;
    }
    notifyListeners();
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
        id: json['id'],
        name: json['room_name'],
        image: null,
        lastMessageText: json['last_message_text'],
        lastMessageTime: DateTime.fromMillisecondsSinceEpoch(
            json['last_message_time'] * 1000),
        members: json['users'].map<int>((u) => u['user_id'] as int).toList(),
        newMessagesCount: json['new_messages'] ?? 0,
      );
}
