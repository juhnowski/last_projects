class ChatRequest {
  final String name = '';
  final Map payload = {};
  ChatRequest();
  factory ChatRequest.getRoomList() = ChatGetRoomListRequest;
  factory ChatRequest.createRoom(List<int> userIds) = ChatCreateRoomRequest;
  factory ChatRequest.newRoomMessage(String roomId,
      {String text, List<Map> files}) = ChatNewRoomMessageRequest;
  factory ChatRequest.getRoomMessages(String roomId) =
      ChatGetRoomMessagesRequest;
  factory ChatRequest.readRoomMessages(String roomId, List<String> messageIds) =
      ChatReadRoomMessagesRequest;
}

class ChatGetRoomListRequest extends ChatRequest {
  final String name = 'get_room_list';
  final Map payload = {};
  ChatGetRoomListRequest();
}

class ChatCreateRoomRequest extends ChatRequest {
  final String name = 'create_room';
  final Map payload = {};
  ChatCreateRoomRequest(List<int> userIds) {
    payload['users_to_group'] = userIds;
  }
}

class ChatNewRoomMessageRequest extends ChatRequest {
  final String name = 'new_message';
  final Map payload = {
    'message_type': 'text',
    'create_date': new DateTime.now().millisecondsSinceEpoch / 1000,
  };
  ChatNewRoomMessageRequest(String roomId, {String text, List<Map> files}) {
    payload['room_id'] = roomId;
    payload['payload'] = text ?? '';
    if (files != null) {
      payload['attachments'] = files;
    }
  }
}

class ChatGetRoomMessagesRequest extends ChatRequest {
  final String name = 'get_room_messages';
  final Map payload = {};
  ChatGetRoomMessagesRequest(String roomId) {
    payload['room_id'] = roomId;
  }
}

class ChatReadRoomMessagesRequest extends ChatRequest {
  final String name = 'message_has_read';
  final Map payload = {};
  ChatReadRoomMessagesRequest(String roomId, List<String> messageIds) {
    payload['room_id'] = roomId;
    payload['messages_id'] = messageIds;
  }
}
