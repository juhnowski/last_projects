import 'package:flutter/material.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/widgets/activities/details.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';

class SingleActivityScreen extends StatelessWidget {
  final Activity item;

  SingleActivityScreen(this.item);

  @override
  Widget build(BuildContext context) {
    return BackgroundedScaffold(
      appBar: AppBar(
        elevation: 0.8,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Активности',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Container(
              child: Row(
                children: <Widget>[
//                 IconButton(icon: Icon(FontAwesomeIcons.solidEnvelope), onPressed: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatOpenScreen(currentLeader, true)));
//                 }),
//                 IconButton(icon: Icon(FontAwesomeIcons.plus), onPressed: (){
//
//                 })
                ],
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: ActivityDetails(item: item),
      ),
    );
  }
}
