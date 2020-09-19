class ChatEvent {
  ChatEvent();
  factory ChatEvent.roomList(Map message) = ChatRoomListEvent;
  factory ChatEvent.roomCreated(Map message) = ChatRoomCreatedEvent;
  factory ChatEvent.userAddedToGroup(Map message) = ChatUserAddedToRoomEvent;
  factory ChatEvent.roomUsers(Map message) = ChatRoomUsersListEvent;
  factory ChatEvent.roomMessages(Map message) = ChatRoomMessagesListEvent;
  factory ChatEvent.newMessage(Map message) = ChatRoomNewMessageEvent;
  factory ChatEvent.roomAlreadyExist(Map message) = ChatRoomAlreadyExistEvent;
  factory ChatEvent.messageRead(Map message) = ChatRoomMessagesReadEvent;
  factory ChatEvent.userLogout(Map message) = ChatUserLogoutEvent;
  factory ChatEvent.userLogin(Map message) = ChatUserLoginEvent;
  factory ChatEvent.authError(Map message) = ChatAuthErrorEvent;
  factory ChatEvent.connectionError() = ChatConnectionErrorEvent;
  factory ChatEvent.connectionOpen() = ChatConnectionOpenEvent;
}

class ChatRoomListEvent extends ChatEvent {
  List rooms;
  ChatRoomListEvent(Map message) {
    rooms = message['user_rooms'];
  }
}

class ChatRoomCreatedEvent extends ChatEvent {
  String roomId;
  String roomName;
  List<int> userIds;

  ChatRoomCreatedEvent(Map message) {
    roomId = message['room_id'];
    roomName = message['room_name'];
    userIds = message['users'].cast<int>();
  }
}

class ChatUserAddedToRoomEvent extends ChatEvent {
  int userId;
  String roomId;
  ChatUserAddedToRoomEvent(Map message) {
    userId = message['user_id'];
    roomId = message['room_id'];
  }
}

class ChatRoomUsersListEvent extends ChatEvent {
  List<int> userIds;
  ChatRoomUsersListEvent(Map message) {
    userIds = message['users'].cast<int>();
  }
}

class ChatRoomMessagesListEvent extends ChatEvent {
  String roomId;
  List<Map> messages = [];

  ChatRoomMessagesListEvent(Map message) {
    if (message.containsKey('data') && message['data'].isNotEmpty) {
      roomId = message['data']['room_id'];
      messages = message['data']['messages']
          .map<Map>((msg) => {
                'id': msg['id'],
                'text': msg['payload'],
                'author_id': int.parse(msg['author']),
                'created_at': msg['date'],
                'is_new': msg['read'] == 0,
                'attachments':
                    msg.containsKey('attachments') ? msg['attachments'] : null,
              })
          .toList();
    }
  }
}

class ChatRoomNewMessageEvent extends ChatEvent {
  String roomId;
  Map<String, dynamic> message;

  ChatRoomNewMessageEvent(Map msg) {
    roomId = msg['room_id'];
    message = {
      'id': msg['message_id'],
      'text': msg['message_payload'],
      'author_id': msg['author_id'],
      'created_at': msg['create_date'],
      'is_new': msg['read'] == 0,
      'attachments':
          msg.containsKey('attachments') && msg['attachments'].isNotEmpty
              ? msg['attachments']
              : null,
    };
  }
}

class ChatRoomAlreadyExistEvent extends ChatEvent {
  String roomId;
  ChatRoomAlreadyExistEvent(Map message) {
    roomId = message['room_id'];
  }
}

class ChatRoomMessagesReadEvent extends ChatEvent {
  List<String> messageIds;
  String roomId;
  int userId;

  ChatRoomMessagesReadEvent(Map message) {
    userId = message['user_id'];
    roomId = message['room_id'];
    messageIds = message['messages_id'].cast<String>();
  }
}

class ChatUserLogoutEvent extends ChatEvent {
  ChatUserLogoutEvent(Map message);
}

class ChatUserLoginEvent extends ChatEvent {
  ChatUserLoginEvent(Map message);
}

class ChatAuthErrorEvent extends ChatEvent {
  ChatAuthErrorEvent(Map message);
}

class ChatConnectionErrorEvent extends ChatEvent {
  ChatConnectionErrorEvent();
}

class ChatConnectionOpenEvent extends ChatEvent {
  ChatConnectionOpenEvent();
}
