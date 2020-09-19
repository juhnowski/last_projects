import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:provider/provider.dart';
import 'package:rsv_mobile/blocs/chat_bloc.dart';
import 'package:rsv_mobile/models/chat/chat_room.dart';
import 'package:rsv_mobile/models/chat/chat_room_member.dart';
import 'package:rsv_mobile/models/files.dart';
import 'package:rsv_mobile/models/task.dart';
import 'package:rsv_mobile/models/user.dart';
import 'package:rsv_mobile/repositories/room_member_repository.dart';
import 'package:rsv_mobile/repositories/tasks_repository.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rsv_mobile/widgets/UI/rounded_button.dart';
import 'package:rsv_mobile/widgets/activities/confirmations.dart';
import 'package:rsv_mobile/widgets/activities/horizontal_list.dart';
import 'package:rsv_mobile/widgets/home/file_item.dart';
import 'package:rsv_mobile/widgets/home/user_info.dart';
import 'package:rsv_mobile/widgets/text.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rsv_mobile/screens/activities/activities_screen.dart';
import 'package:rsv_mobile/widgets/home/user_image.dart';
import 'package:rsv_mobile/screens/chat/chat_open_screen.dart';
import 'package:rsv_mobile/widgets/home/custom_button.dart';
import 'package:rsv_mobile/screens/sub/tasks_screen.dart';
import 'package:rsv_mobile/screens/sub/add_task.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkService>(builder: (context, networkService, child) {
      return Container(
        child: (!networkService.user.isLoggedIn)
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : (networkService.user.isLeader)
                ? LeaderHomeScreen(Provider.of<RoomMemberRepository>(context)
                    .getMember(networkService.user.userId))
                : StudentHomeScreen(Provider.of<RoomMemberRepository>(context)
                    .getMember(networkService.user.userId)),
//            child: StudentHomeScreen(user.data),
      );
    });
  }
}

class StudentHomeScreen extends StatelessWidget {
  final ChatRoomMember user;
  StudentHomeScreen(this.user);
  @override
  Widget build(BuildContext context) {
    var items = <Widget>[
      Container(
        child: UserInfo(
          user,
          me: true,
        ),
      ),
      //ProgressScreen(),
      Heading(
        'Ближайшие активности',
        screen: ActivitiesScreen(),
      ),
      HorizontalActivities(context),
      Heading(
        'Чат с наставником',
        arrow: false,
//          screen: ChatOpenScreen(
//              chatUserId: Provider.of<NetworkService>(context, listen: false).user.group.leaderId),
      ),
      Consumer<ChatBLoC>(builder: (context, chat, child) {
        return StreamBuilder<ChatRoom>(
            stream: chat.leaderRoom,
            builder: (context, snapshot) {
              var member =
                  Provider.of<RoomMemberRepository>(context, listen: false)
                      .getMember(chat.leaderId);
              return HomeChatItem(member, snapshot.data);
            });
      }),
      Heading(
        'Задачи',
        screen: TasksScreen(),
      ),
      HomeTasksItem(),
      Heading('Файлы', arrow: false
//                onTap: () {
//                  Navigator.pushNamed(context, '/files');
//                },
          ),
      HomeFilesView(),
//        Heading(
//          'Сообщества',
//          screen: GroupsScreen(),
//        ),
//        Label('Заявки'),
//        GroupInvitation(),
//        Label('Популярные'),
//        GroupItem('FAQ c организаторами', 'Вопросы и обсуждения', 1231,
//            'http://lorempixel.com/output/technics-q-c-640-480-3.jpg'),
//        GroupItem('Пилотная группа', 'Обсуждение здравоохранения', 2413,
//            'http://lorempixel.com/output/business-q-c-640-480-5.jpg'),
    ];

    if (Provider.of<NetworkService>(context, listen: false).user.curatorId != null) {
      items.add(Heading('Вопрос Куратору', arrow: false));
      items.add(ContactCurator());
    }
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    ));
  }
}

class LeaderHomeScreen extends StatelessWidget {
  final ChatRoomMember user;
  LeaderHomeScreen(this.user);

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[
      Expanded(
          child: Container(
              child: ListView(
        padding: Margin.all(context),
        children: <Widget>[
          Container(
            child: UserInfo(
              user,
              me: true,
              leader: true,
            ),
          ),
          //ProgressScreen(),
          Heading(
            'Ближайшие активности',
            screen: ActivitiesScreen(),
          ),
          HorizontalActivities(context),
          Heading(
            'Приглашение на встречу',
            arrow: false,
          ),
          ConfirmationActivities(context),
          Heading('Файлы', arrow: false
//                onTap: () {
//                  Navigator.pushNamed(context, '/files');
//                },
              ),
          HomeFilesView(),
//              Heading(
//                'Сообщества',
//                screen: GroupsScreen(),
//              ),
//              Label('Заявки'),
//              GroupInvitation(),
//              Label('Популярные'),
//              GroupItem('FAQ c организаторами', 'Вопросы и обсуждения', 1231,
//                  'http://lorempixel.com/output/technics-q-c-640-480-3.jpg'),
//              GroupItem('Пилотная группа', 'Обсуждение здравоохранения', 2413,
//                  'http://lorempixel.com/output/business-q-c-640-480-5.jpg'),
        ],
      ))),
    ];

    if (Provider.of<NetworkService>(context, listen: false).user.curatorId != null) {
      items.add(Heading('Вопрос Куратору', arrow: false));
      items.add(ContactCurator());
    }

    return Container(
      child: Column(
        children: items,
      ),
    );
  }
}

class HomeFilesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const prefix0.EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<Files>(builder: (context, files, child) {
        return Column(
          children: files.allFiles
              .map<Widget>((file) => FileItem(file, showFavorite: false))
              .take(4)
              .toList()
                ..add(Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 30.0),
                  child: RoundedButton(
                    label: 'Посмотреть все материалы',
                    color: const Color(0xFF3AA0FD),
                    onPressed: () {
                      Navigator.pushNamed(context, '/files');
                    },
                  ),
                )),
        );
      }),
    );
  }
}

//class FileItem extends StatelessWidget {
//  final String type;
//
//  FileItem(this.type);
//
//  @override
//  Widget build(BuildContext context) {
////    Widget roundRect = ClipRRect(
////        borderRadius: BorderRadius.circular(80),
////        child:
////    );
//
//    Widget fileContainer = Container(
//      height: 80,
//      width: 80,
//      decoration: new BoxDecoration(
//        image: new DecorationImage(
//            image: AssetImage('assets/images/' + type + '.png'),
//            fit: BoxFit.cover),
//      ),
//    );
//
//    return Container(
//      width: 100,
//      padding: EdgeInsets.all(10),
//      child: Column(
//        children: <Widget>[
//          fileContainer,
//        ],
//      ),
//    );
//  }
//}

class ContactCurator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactCuratorState();
  }
}

class ContactCuratorState extends State<ContactCurator> {
  bool sent = false;
  TextEditingController textController = new TextEditingController();

  Widget info = Container(
    padding: EdgeInsets.only(bottom: 20),
    child: Row(
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.circular(Size.userImageSize()),
            child: Container(
              height: Size.userImageSize(),
              width: Size.userImageSize(),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'info@rsv.ru',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text('Мы всегда на связи')
            ],
          ),
        )
      ],
    ),
  );

  Widget sentMessage = Container(
    child: Text(
        'Сообщение отправлено. Куратор программы свяжется с вами в ближайшее время'),
  );

  _sendMessage() {
    if (textController.text.isNotEmpty) {
      setState(() {
        Provider.of<ChatBLoC>(context, listen: false)
            .sendMessageToCurator(textController.text.toString());
        sent = true;
      });
    } else {
      print('input is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget sendButton = Container();
    if (sent == false) {
      sendButton = CustomButton(
        text: 'Отправить',
        onPressed: _sendMessage,
      );
    }

    return Container(
      padding: EdgeInsets.only(
        left: Margin.margin(context, def: 20),
        right: Margin.margin(context, def: 20),
        bottom: Margin.margin(context, def: 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: sent
            ? [sentMessage]
            : [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffe5e5e5),
                  ),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Спроси что нибудь...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                sendButton
              ],
      ),
    );
  }
}

class HomeChatItem extends StatelessWidget {
  final ChatRoomMember _user;
  final ChatRoom room;
  HomeChatItem(this._user, this.room);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !_user.isLoaded
          ? null
          : () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatOpenScreen(
                            roomId: room?.id,
                            chatUserId: _user?.userId,
                          )));
            },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0xffdddddd),
                offset: Offset(0.0, 0.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      !_user.isLoaded
                          ? Container(
                              height: 56,
                              width: 0,
                            )
                          : UserImage(
                              image: _user.avatar,
                              size: 56,
                            ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: !_user.isLoaded
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                _user.fullName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      room?.lastMessageText ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF676767)),
                                    ),
                                  ),
                                  //Expanded(),
                                  Text(
                                    room?.lastMessageTimeFormatted ?? '',
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              )
                            ],
                          ),
                  ),
                ),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                      color: Color(0xff3AA0FD),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Center(
                      child: Icon(
                    FontAwesomeIcons.solidComment,
                    color: Colors.white,
                  )),
                )
              ],
            ),
          )),
    );
  }
}

class HomeTasksItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xffdddddd),
            offset: Offset(0.0, 0.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Ближайшие задачи',
                  style: TextStyle(color: Color(0xff979797), fontSize: 14)),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.plusCircle,
                  color: Color(0xff3AA0FD),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddTaskScreen()));
                },
              )
            ],
          ),
          //task items
          SizedBox(
            height: 165.0,
            child: Consumer<TasksRepository>(
              builder: (context, tasksRepository, child) {
                return RefreshIndicator(
                  displacement: 0.0,
                  onRefresh: () async {
                    await tasksRepository.loadTasks();
                  },
                  child: StreamBuilder<List<Task>>(
                      stream: tasksRepository.current,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Task>> snapshot) {
                        if (!snapshot.hasData || snapshot.data.length == 0) {
                          return child;
                        }
                        return ListView.builder(
                            shrinkWrap: false,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              return TaskItem(
                                snapshot.data[i],
                              );
                            });
                      }),
                );
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Задач пока нет',
                  style: TextStyle(fontSize: FontSize.small()),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
