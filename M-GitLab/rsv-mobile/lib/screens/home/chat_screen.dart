import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/blocs/chat_bloc.dart';
import 'package:rsv_mobile/models/chat/chat_room.dart';
import 'package:rsv_mobile/widgets/text.dart';
import 'package:rsv_mobile/widgets/chat/chat_item.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    WssConnect();

    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<ChatBLoC>(context, listen: false).refreshRoomList();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Heading(
              'Чаты',
              arrow: false,
              onTap: () {
                print(Provider.of<ChatBLoC>(context, listen: false)
                    .getConnectionStatus());
              },
            ),
            Expanded(child: Container(child: Consumer<ChatBLoC>(
              builder: (context, chat, child) {
                return StreamBuilder<List<ChatRoom>>(
                    stream: chat.rooms,
                    initialData: [],
                    builder: (context, AsyncSnapshot<List<ChatRoom>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('Connecting...');
                      } else {
                        return ListView.builder(
                            padding: Margin.all(context),
//                            itemCount: snapshot.data.length + 1,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
//                              if (i == 0) {
//                                return child;
//                                return child;
//                              } else {
//                                return ChatItem(snapshot.data[i - 1]);
//                                var room = snapshot.data[i - 1];
                              var room = snapshot.data[i];
                              return ChangeNotifierProvider<ChatRoom>.value(
                                value: room,
                                child: ChatItem(room),
                              );
//                              }
                            });
                      }
                    });
              },
//              child: Container(
//                  padding: EdgeInsets.symmetric(vertical: 10),
//                  child: Container(
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(8),
//                      color: Color(0xfff2f2f2),
//                    ),
//                    child: TextField(
//                      decoration: InputDecoration(
//                          hintText: 'Поиск',
//                          prefixIcon: Icon(Icons.search),
//                          //  contentPadding: EdgeInsets.all(10),
//                          border: InputBorder.none),
//                    ),
//                  )),
            )))
          ],
        ),
      ),
    );
  }
}
