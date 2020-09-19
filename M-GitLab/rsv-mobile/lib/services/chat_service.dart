import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:rsv_mobile/services/chat/chat_events.dart';
import 'package:rsv_mobile/services/chat/chat_messages.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatService {
  final _chatEventStreamController = StreamController<ChatEvent>();
  Stream<ChatEvent> get events => _chatEventStreamController.stream;

  final _chatRequestsStreamController = StreamController<ChatRequest>();
  StreamSink<ChatRequest> get requests => _chatRequestsStreamController.sink;

  final String domain;
  final Random _random = Random();

  List<ChatRequest> requestBuffer = [];

  Timer _pingpong;

  bool reconnectionEnabled = true;
  int reconnectionDelay = 1000;
  int reconnectionDelayMax = 5000;
  int reconnectionAttempts = 1000;
  double randomizationFactor = 0.5;

  IOWebSocketChannel _webSocketChannel;
  int _reconnectionDelayCurrent;
  int _connectionAttemptsNumber;
  bool _connectionInProgress = false;
  String _jwt;

  bool hasFirstPing = false;

  get isConnected =>
      _webSocketChannel != null && _webSocketChannel.closeCode == null;

  String get jwt => _jwt;
  set jwt(String token) {
    print('set chat jwt $token');
    if (token == null) {
      _jwt = null;
      closeConnection();
    } else {
      _jwt = token;
      _connectionAttemptsNumber = 0;
      _reconnectionDelayCurrent = reconnectionDelay;
      if (!isConnected) {
        openConnection();
      }
    }
  }

  ChatService(
      {@required this.domain,
      this.reconnectionEnabled = true,
      this.reconnectionDelay = 1000,
      this.reconnectionDelayMax = 5000,
      this.reconnectionAttempts = 1000}) {
    _reconnectionDelayCurrent = reconnectionDelay;

    _chatRequestsStreamController.stream.listen((ChatRequest req) {
      if (isConnected) {
        sendMessageToServer(req.name, req.payload);
      } else {
        requestBuffer.add(req);
        if (!_connectionInProgress) {
          openConnection();
        }
      }
    });
  }

  sendMessageToServer(String type, Map payload) {
    print('isConnected $isConnected');
    print('_webSocketChannel $_webSocketChannel');
    print('Chat -> $type: $payload');
    if (isConnected) {
      _webSocketChannel?.sink
          ?.add(json.encode({'jwt': _jwt, 'name': type, 'payload': payload}));
    } else {
      throw Exception('Unable to send message, connection closed');
    }
  }

  ChatEvent _makeEvent(Map message) {
    ChatEvent event;
    switch (message['event_type']) {
      case 'authorization error':
        event = ChatEvent.authError(message);
        break;
      case 'room_list':
        event = ChatEvent.roomList(message);
        break;
      case 'room_created':
        event = ChatEvent.roomCreated(message);
        break;
      case 'user_added_to_group':
        event = ChatEvent.userAddedToGroup(message);
        break;
      case 'room_users':
        event = ChatEvent.roomUsers(message);
        break;
      case 'room_messages':
        event = ChatEvent.roomMessages(message);
        break;
      case 'new_message':
        event = ChatEvent.newMessage(message);
        break;
      case 'room_existed':
        event = ChatEvent.roomAlreadyExist(message);
        break;
      case 'message_has_read':
        event = ChatEvent.messageRead(message);
        break;
      case 'user_logout':
        event = ChatEvent.userLogout(message);
        break;
      case 'user_logout':
        event = ChatEvent.userLogin(message);
        break;
    }
    return event;
  }

  _ping() {
    if (isConnected) {
      _webSocketChannel.sink.add('PING');
      print('PING');
    }
  }

  openConnection() {
    closeConnection();
    if (_jwt == null) {
      return;
    }
    print('Chat Openning...');
    print(domain);
    print(_jwt);

    _connectionAttemptsNumber++;

    _webSocketChannel =
        IOWebSocketChannel.connect('wss://$domain/ws?jwt=$_jwt');

    _pingpong?.cancel();
    _pingpong = Timer.periodic(Duration(seconds: 30), (timer) {
      _ping();
    });
    _ping();
    if (requestBuffer.isNotEmpty) {
      requestBuffer.forEach((req) {
        sendMessageToServer(req.name, req.payload);
      });
    }
    print('_connectionInProgress $_connectionInProgress');

    _connectionInProgress = false;

    _webSocketChannel.stream.listen(
      (payload) {
        print('Chat <- $payload');
        _reconnectionDelayCurrent = reconnectionDelay;

        if (!hasFirstPing) {
          hasFirstPing = true;
          ChatEvent event = ChatEvent.connectionOpen();
          _chatEventStreamController.sink.add(event);
          print('Chat Connected');
        }

        if (payload == 'PONG') {
          return;
        }

        Map message = json.decode(payload);
        ChatEvent event = _makeEvent(message);
        _chatEventStreamController.sink.add(event);

        if (event is ChatAuthErrorEvent) {
          reconnectionEnabled = false;
          print('Chat auth error, need to refresh jwt tokent');
        }
      },
      onDone: () {
        print('Chat Websocket Done');
        ChatEvent event = ChatEvent.connectionError();
        _chatEventStreamController.sink.add(event);
        _reopenConnection();
      },
      onError: (error) {
        print('Chat Websocket Error');
//        ChatEvent event = ChatEvent.connectionError();
//        _chatEventStreamController.sink.add(event);
//        _reopenConnection();
        closeConnection();
      },
    );
  }

  _reopenConnection() {
    if (_connectionInProgress) return;
    _connectionInProgress = true;

    if (_connectionAttemptsNumber > reconnectionAttempts) {
      print('reconnection attempts limit reached!');
      reconnectionEnabled = false;
      return;
    }
    if (reconnectionEnabled) {
      int delay = (_reconnectionDelayCurrent +
              reconnectionDelay *
                  (_random.nextDouble() * 2.0 - 1.0) *
                  randomizationFactor)
          .round();
      if (delay > reconnectionDelayMax) {
        delay = reconnectionDelayMax;
      }
      print('delay: $delay');
      _reconnectionDelayCurrent += delay;
      Future.delayed(Duration(milliseconds: delay), () => openConnection());
    }
  }

  closeConnection() {
    hasFirstPing = false;
    _webSocketChannel?.sink?.close(status.goingAway);
    _webSocketChannel = null;
    _pingpong?.cancel();
  }

  dispose() {
    _chatEventStreamController.close();
    _chatRequestsStreamController.close();
    closeConnection();
  }
}
