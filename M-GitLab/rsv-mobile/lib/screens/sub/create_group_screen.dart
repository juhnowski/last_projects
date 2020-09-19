import 'package:flutter/material.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';
import 'package:rsv_mobile/widgets/groups/select_users_button.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class CreateGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundedScaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Новое сообщество',
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text(
                'Создать',
                style: TextStyle(color: Color(0xff1184ED)),
              ),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          padding: Margin.all(context),
          child: Column(
            children: <Widget>[SelectImage(), SelectUsersButton()],
          ),
        ));
  }
}

class SelectImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xfff2f2f2))),
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 60,
                width: 60,
                margin: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    color: Color(0xfff2f2f2),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Image.asset(
                    'assets/images/image.png',
                    height: 40,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Фото на фон',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                    Text(
                      'Выбрать',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color(0xff8F9398)),
                    )
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ));
  }
}
