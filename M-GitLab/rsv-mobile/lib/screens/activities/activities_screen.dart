import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/user.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rsv_mobile/widgets/activities/vertical_list.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';
import 'package:rsv_mobile/screens/chat/chat_open_screen.dart';

class ActivitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return BackgroundedScaffold(
      appBar: AppBar(
        elevation: 0.8,
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text('Активности',
                style: new TextStyle(color: Color(0xff1184ED))),
            Expanded(child: Container(),),
            Container(
              child: Consumer<NetworkService>(
                builder: (context, networkService, child) {
                  List<Widget> actions = [];
                  if (networkService.user.isStudent) {
                    actions.add(Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AddMeetingButton(networkService.user.group.leaderId),
                    ));
                  }
                  return Row(children: actions);
                },
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: VerticalActivities(context)),
        ],
      ),
    );
  }
}
