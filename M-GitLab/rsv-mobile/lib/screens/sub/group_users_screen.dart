import 'package:flutter/material.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class GroupUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundedScaffold(
      appBar: AppBar(
        title: Text('Участники сообщества'),
      ),
      body: Container(
        child: ListView(
          padding: Margin.all(context),
          children: <Widget>[],
        ),
      ),
    );
  }
}
