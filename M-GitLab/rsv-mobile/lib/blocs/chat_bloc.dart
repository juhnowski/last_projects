/*
*
* streams
* rooms Stream<List<Room>>
* roomMessages Stream<List<RoomMessage>>
* newMessagesCount Stream<int>
*
* openRoom(roomId)
* sendMessage(roomId, {text, attachments})
* receiveMessage(message)
* closeRoom(roomId)
* startChatWithUser(userId)
*
*
*
* */

import 'dart:async';

import 'package:rsv_mobile/models/chat/chat_room.dart';
import 'package:rsv_mobile/models/chat/chat_room_message.dart';
import 'package:rsv_mobile/models/profile_file.dart';
import 'package:rsv_mobile/models/user.dart';
import 'package:rsv_mobile/repositories/room_member_repository.dart';
import 'package:rsv_mobile/services/chat/chat_events.dart';
import 'package:rsv_mobile/services/chat/chat_messages.dart';
import 'package:rsv_mobile/services/chat_service.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rxdart/rxdart.dart';

class ChatBLoC {
  final ChatService _chatService;
  final RoomMemberRepository _roomMemberRepository;
  NetworkService _networkService;

  final _connectionStreamController = BehaviorSubject<bool>();
  Stream<bool> get isOnline => _connectionStreamController.stream;

  final _newMessagesCountStreamController = BehaviorSubject<int>();
  Stream<int> get newMessagesCount => _newMessagesCountStreamController.stream;

  final _roomsStreamController = BehaviorSubject<List<ChatRoom>>();
  Stream<List<ChatRoom>> get rooms => _roomsStreamController.stream;

  final _currentRoomStreamController = BehaviorSubject<ChatRoom>();
  Stream<ChatRoom> get currentRoom => _currentRoomStreamController.stream;

  final _leaderRoomStreamController = BehaviorSubject<ChatRoom>();
  Stream<ChatRoom> get leaderRoom => _leaderRoomStreamController.stream;
  final _studentRoomStreamController = BehaviorSubject<ChatRoom>();
  Stream<ChatRoom> get studentRoom => _studentRoomStreamController.stream;
  final _curatorRoomStreamController = BehaviorSubject<ChatRoom>();
  Stream<ChatRoom> get curatorRoom => _curatorRoomStreamController.stream;

  final _messagesStreamController = BehaviorSubject<List<ChatRoomMessage>>();
  Stream<List<ChatRoomMessage>> get messages =>
      _messagesStreamController.stream;

  int currentUserId;
  String _currentRoomId;

  int leaderId;
  int studentId;
  int curatorId;

  String _messageToCurator;
  String _messageToStudent;
  String _messageToLeader;

  List<int> _waitForRoomWithUserIds;

  Map<String, ChatRoom> _rooms = {};
  Map<String, List<ChatRoomMessage>> _roomsMessages = {};

  set network(NetworkService networkService) {
    _networkService = networkService;
    print('chat update user:');
    print('${_networkService.user.userId}');
    print('${_networkService.jwt}');

    currentUserId = _networkService.user.userId;
    leaderId = _networkService.user.leaderId;
    studentId = _networkService.user.studentId;
    curatorId = _networkService.user.curatorId;

    if (currentUserId == null) {
      clear();
    }

    if (_chatService.jwt != _networkService.jwt) {
      _chatService.jwt = _networkService.jwt;
    }
  }

  clear() {
    _rooms = {};
    _roomsMessages = {};
    _emitNewMessagesCount();
    _emitSpecialRoom(null);
    _emitRoomList();
    _emitCurrentRoomMessages();
  }

  Map getConnectionStatus() {
    return {
      'isConnected': _chatService.isConnected,
    };
  }

  refreshRoomList() {
    _chatService.requests.add(ChatRequest.getRoomList());
  }

  openRoomWithUser(int userId) {
    int roomSize = userId == currentUserId ? 1 : 2;
    var room = _rooms.values.firstWhere((room) {
      return room.members.length == roomSize &&
          room.members.contains(currentUserId) &&
          room.members.contains(userId);
    }, orElse: () => null);

    if (room != null) {
      openRoom(room.id);
    } else {
      _waitForRoomWithUserIds = <int>[userId];
      _createRoom(_waitForRoomWithUserIds);
    }
  }

  openRoom(String roomId) {
    _currentRoomId = roomId;
    _currentRoomStreamController.add(_rooms[_currentRoomId]);
    _getRoomMessages(_currentRoomId);
    _emitCurrentRoomMessages();
  }

  closeCurrentRoom() {
    _currentRoomId = null;
    _currentRoomStreamController.add(null);
  }

  sendMessageToCurrentRoom({String text, List<ProfileFile> files}) {
    if (_currentRoomId != null) {
      _sendMessage(_currentRoomId, text: text, files: files);
    }
  }

  sendMessageToCurator(String message) {
    var room = _rooms.values.singleWhere((v) {
      return v.isCurator;
    }, orElse: () => null);

    print('curatorId');

    if (room != null) {
      _sendMessage(room.id, text: message);
    } else {
      _messageToCurator = message;
      _createRoom([curatorId]);
    }
  }

  sendMessageToStudent(String message) {
    var room = _rooms.values.singleWhere((v) {
      return v.isStudent;
    }, orElse: () => null);
    if (room != null) {
      _sendMessage(room.id, text: message);
    } else {
      _messageToStudent = message;
      _createRoom([studentId]);
    }
  }

  sendMessageToLeader(String message) {
    var room = _rooms.values.singleWhere((v) {
      return v.isLeader;
    }, orElse: () => null);
    if (room != null) {
      _sendMessage(room.id, text: message);
    } else {
      _messageToLeader = message;
      _createRoom([leaderId]);
    }
  }

  sendMessageToPair(String message) {
    if (currentUserId == leaderId) {
      sendMessageToStudent(message);
    } else {
      sendMessageToLeader(message);
    }
  }

  _sendMessage(String roomId, {String text, List<ProfileFile> files}) {
    _chatService.requests.add(ChatRequest.newRoomMessage(roomId,
        text: text, files: files?.map<Map>((f) => f.toMap())?.toList()));
  }

  _getRoomMessages(String roomId) {
    _chatService.requests.add(ChatRequest.getRoomMessages(_currentRoomId));
  }

  _createRoom(List<int> userIds) {
    if (userIds.contains(null)) {
      throw Exception('Unable to create room with id of member = null');
    }
    _chatService.requests.add(ChatRequest.createRoom(userIds));
  }

  _readRoomMessages(String roomId) {
    List<String> messageIds = [];
    _roomsMessages[roomId].forEach((message) {
      if (message.isNew) {
        messageIds.add(message.id);
        message.isNew = false;
      }
    });
    _rooms[roomId].newMessagesCount = 0;
    _chatService.requests.add(ChatRequest.readRoomMessages(roomId, messageIds));

    _emitNewMessagesCount();
    _emitCurrentRoomMessages();
    _emitRoomList();
  }

  ChatBLoC(
      this._chatService, this._roomMemberRepository) {
    print('build chat bloc');

    _curatorRoomStreamController.listen((room) {
      if (_messageToCurator != null) {
        _sendMessage(room.id, text: _messageToCurator);
        _messageToCurator = null;
      }
    });

    _studentRoomStreamController.listen((room) {
      if (_messageToStudent != null) {
        _sendMessage(room.id, text: _messageToStudent);
        _messageToStudent = null;
      }
    });

    _leaderRoomStreamController.listen((room) {
      if (_messageToLeader != null) {
        _sendMessage(room.id, text: _messageToLeader);
        _messageToLeader = null;
      }
    });

    _chatService.openConnection();
    _chatService.events.listen((e) {
      if (e is ChatConnectionOpenEvent) {
        _setOnline(true);
      } else if (e is ChatConnectionErrorEvent) {
        _setOnline(false);
      } else if (e is ChatRoomListEvent) {
        _onRoomList(e);
      } else if (e is ChatRoomCreatedEvent) {
        _onRoomCreate(e);
      } else if (e is ChatUserAddedToRoomEvent) {
        _onUserAddedToRoom(e);
      } else if (e is ChatRoomUsersListEvent) {
        _onRoomUsersList(e);
      } else if (e is ChatRoomMessagesListEvent) {
        _onRoomMessagesList(e);
      } else if (e is ChatRoomNewMessageEvent) {
        _onRoomNewMessage(e);
      } else if (e is ChatRoomAlreadyExistEvent) {
        _onRoomAlreadyExist(e);
      } else if (e is ChatRoomMessagesReadEvent) {
        _onRoomMessagesRead(e);
      } else if (e is ChatUserLogoutEvent) {
        _onUserLogout(e);
      } else if (e is ChatUserLoginEvent) {
        _onUserLogin(e);
      } else if (e is ChatAuthErrorEvent) {
        _onAuthError(e);
      }
    });
  }

  _setOnline(bool isOnline) {
    _connectionStreamController.sink.add(isOnline);
    if (isOnline) {
      refreshRoomList();
    }
  }

  _onRoomList(ChatRoomListEvent e) async {
    Map<int, Map> users = {};
    e.rooms.forEach((r) {
      r['users'].forEach((u) {
        users[u['user_id']] = u;
      });
    });
    await _roomMemberRepository.syncMembers(users.keys.toList());
    _roomMemberRepository.setUsersOnline(users.values.toList());

    print('onRoomList userId: $currentUserId');

    _rooms = Map.fromIterable(e.rooms,
        key: (v) => v['id'],
        value: (v) {
          ChatRoom room = ChatRoom.fromJson(v);
          _updateRoomAttributes(room);

          return room;
        });

    _emitRoomList();
    _emitNewMessagesCount();

    if (_currentRoomId != null) {
      _getRoomMessages(_currentRoomId);
    }
  }

  _onRoomCreate(ChatRoomCreatedEvent e) async {
    await _roomMemberRepository.syncMembers(e.userIds);

    ChatRoom room = ChatRoom(
      id: e.roomId,
      name: e.roomName,
      members: e.userIds,
    );
    _updateRoomAttributes(room);

    _rooms[room.id] = room;
    _emitRoomList();

    if (_waitForRoomWithUserIds != null && _waitForRoomWithUserIds.length > 0) {
      var waitingUserIds = e.userIds
          .where((id) =>
              _waitForRoomWithUserIds.contains(id) || currentUserId == id)
          .toList();
      if (waitingUserIds.length == e.userIds.length) {
        openRoom(room.id);
        _waitForRoomWithUserIds = null;
      }
    }
  }

  _onUserAddedToRoom(ChatUserAddedToRoomEvent e) {
    //TODO: implement _onUserAddedToRoom
  }

  _onRoomUsersList(ChatRoomUsersListEvent e) {
    //TODO: implement _onRoomUsersList
  }

  _onRoomMessagesList(ChatRoomMessagesListEvent e) {
    _roomsMessages[e.roomId] = e.messages
        .map<ChatRoomMessage>((m) => ChatRoomMessage.fromJson(m))
        .toList();

    if (e.roomId == _currentRoomId) {
      _readRoomMessages(_currentRoomId);
    }

    _emitCurrentRoomMessages();
    _emitRoomList();
  }

  _onRoomNewMessage(ChatRoomNewMessageEvent e) {
    ChatRoomMessage message = ChatRoomMessage.fromJson(e.message);

    _roomsMessages.containsKey(e.roomId)
        ? _roomsMessages[e.roomId].add(message)
        : _roomsMessages[e.roomId] = [message];

    _rooms[e.roomId]
        .addMessage(message, isMine: currentUserId == message.authorId);

    _emitSpecialRoom(_rooms[e.roomId]);

    if (_currentRoomId == e.roomId) {
      _readRoomMessages(_currentRoomId);
    } else {
      _emitNewMessagesCount();
      _emitRoomList();
    }
  }

  _onRoomAlreadyExist(ChatRoomAlreadyExistEvent e) {
    _emitSpecialRoom(_rooms[e.roomId]);
  }

  _onRoomMessagesRead(ChatRoomMessagesReadEvent e) {
//    _roomsMessages[e.roomId]
  }

  _onUserLogout(ChatUserLogoutEvent e) {
    //TODO: implement _onUserLogout
  }

  _onUserLogin(ChatUserLoginEvent e) {
    //TODO: implement _onUserLogin
  }

  _onAuthError(ChatAuthErrorEvent e) {
    _networkService.authValidateJwt();
  }

  dispose() {
    _chatService.dispose();
    _connectionStreamController.close();
    _messagesStreamController.close();
    _roomsStreamController.close();
    _currentRoomStreamController.close();
    _leaderRoomStreamController.close();
    _studentRoomStreamController.close();
    _curatorRoomStreamController.close();
    _newMessagesCountStreamController.close();
  }

  _emitRoomList() {
    var curator =
        _rooms.values.firstWhere((room) => room.isCurator, orElse: () => null);
    var pairUser = _rooms.values.firstWhere((room) => room.isLeader || room.isStudent, orElse: () => null);

    var sorted = _rooms.values
        .where((room) =>
            !room.isLeader &&
            !room.isStudent &&
            !room.isCurator &&
            room.lastMessageTime != null &&
            room.lastMessageTime.millisecondsSinceEpoch > 0)
        .toList()
          ..sort((a, b) {
            return b.lastMessageTime.compareTo(a.lastMessageTime);
          });

    if (pairUser != null) {
      sorted.insert(0, pairUser);
    }
    if (curator != null) {
      sorted.insert(0, curator);
    }
    _roomsStreamController.sink.add(sorted);
  }

  _updateRoomAttributes(ChatRoom room) {
    print('updateRoomAttributes $currentUserId');
    if (room.name == null) {
      var members = room.members.where((v) => v != currentUserId);
      room.name = members
          .map((id) => members.length == 2
              ? _roomMemberRepository.getMember(id).userName
              : _roomMemberRepository.getMember(id).fullName)
          .join(', ');
    }

    if (room.isPersonal) {
      room.image = _roomMemberRepository
          .getMember(room.members.firstWhere((id) => id != currentUserId))
          ?.avatar;
    }

    room.updateMembership(
      currentUserId: currentUserId,
      leaderId: leaderId,
      studentId: studentId,
      curatorId: curatorId,
    );
    _emitSpecialRoom(room);
  }

  _emitSpecialRoom(ChatRoom room) {
    if (room == null) {
      _leaderRoomStreamController.add(null);
    } else {
      if (room.isLeader) {
        _leaderRoomStreamController.add(room);
      }
      if (room.isStudent) {
        _studentRoomStreamController.add(room);
      }
      if (room.isCurator) {
        _curatorRoomStreamController.add(room);
      }
    }
  }

  _emitCurrentRoomMessages() {
    if (_currentRoomId != null) {
      _messagesStreamController.sink.add(_roomsMessages[_currentRoomId]);
    }
  }

  _emitNewMessagesCount() {
    var count = 0;
    var values = _rooms.values;
    if (values.isNotEmpty) {
      count = _rooms.values
          .map((room) => room.newMessagesCount)
          .reduce((acc, v) => (v != null && v > 0) ? acc + v : acc);
//    .map((v) => (v != null && v > 0) ? 1 : 0 )
//        .reduce((acc, v) => acc + v);
    }
    _newMessagesCountStreamController.sink.add(count);
  }

//    Stream<List<Room>> roomsController = StreamController<Stream>
//    rooms Stream<List<Room>>
//    roomMessages Stream<List<RoomMessage>>
//    newMessagesCount Stream<int>

//    openRoom(roomId)
//    sendMessage(roomId, {text, attachments})
//    receiveMessage(message)
//    closeRoom(roomId)
//    startChatWithUser(userId)
}
