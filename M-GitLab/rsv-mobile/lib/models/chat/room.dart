import 'package:flutter/cupertino.dart';
import 'package:rsv_mobile/models/chat/chat_room_message.dart';
import 'package:rsv_mobile/utils/time.dart';

class ChatRoom extends ChangeNotifier {
  String id;
  String image;
  String name;
  String _lastMessageText;
  DateTime _lastMessageTime;
  String lastMessageTimeFormatted;
  int newMessagesCount = 0;
  List<ChatRoomMessage> messages = [];
  List<int> members;

  set lastMessageTime(DateTime datetime) {
    if (datetime != null) {
      _lastMessageTime = datetime;
      lastMessageTimeFormatted =
          TimeUtils.getFormattedLastMessageTime(datetime);
    }
  }

  DateTime get lastMessageTime => _lastMessageTime;

  set lastMessageText(String text) {
    _lastMessageText = text;
  }

  String get lastMessageText => _lastMessageText ?? '';

  get membersCount => members.length;
  get isOnline => false;

  get isGroup => members.length > 2;
  get isPersonal => members.length == 2;

  bool isLeader(int leaderId) {
    return isPersonal && members.contains(leaderId);
  }

  ChatRoom({
    this.id,
    this.image,
    this.name,
    String lastMessageText,
    DateTime lastMessageTime,
    this.members,
    this.newMessagesCount,
  }) {
    if (lastMessageTime != null) {
      lastMessageTimeFormatted =
          TimeUtils.getFormattedLastMessageTime(lastMessageTime);
      _lastMessageTime = lastMessageTime;
    }
    if (lastMessageText != null) {
      _lastMessageText = lastMessageText;
    }
  }

  setMessages(List<ChatRoomMessage> allMessages) {
    // TODO: REMOVE
//    messages = allMessages;
//    lastMessageText = messages.first.text;
//    lastMessageTime = messages.first.createdAt;
  }

  addMessage(ChatRoomMessage message) {
    _lastMessageText = message.text;
    lastMessageTime = message.createdAt;
    newMessagesCount++;
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
        newMessagesCount: json['new_messages'],
      );
}
