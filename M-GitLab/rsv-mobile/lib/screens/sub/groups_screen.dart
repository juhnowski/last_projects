import 'package:flutter/material.dart';
import 'package:rsv_mobile/widgets/groups/group_item.dart';
import 'package:rsv_mobile/screens/sub/create_group_screen.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class GroupsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/homebg.png'), fit: BoxFit.cover),
          color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Сообщества'),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 10),
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateGroupScreen()));
              },
            ),
          ],
        ),
        body: SafeArea(
            child: Container(
          // color: Colors.white,
          child: ListView(
            padding: Margin.all(context),
            children: <Widget>[
              GroupInvitation(),
              GroupItem('FAQ c организаторами', 'Вопросы и обсуждения', 1231,
                  'http://lorempixel.com/output/technics-q-c-640-480-3.jpg'),
              GroupItem('Пилотная группа', 'Обсуждение здравоохранения', 2413,
                  'http://lorempixel.com/output/business-q-c-640-480-5.jpg'),
              GroupItem(
                  'Группа 19.2',
                  'Обсуждение нехватки рабочих мест',
                  54417,
                  'http://lorempixel.com/output/technics-q-c-640-480-4.jpg')
            ],
          ),
        )),
      ),
    );
  }
}
