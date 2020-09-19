import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rsv_mobile/models/activities/activity.dart';

class ActivityDate extends StatelessWidget {
  final DateTime date;
  final ActivityType type;
  final Color color;
  final dateFormat = new DateFormat.yMMMMd('ru');
  final timeFormat = new DateFormat.Hm('ru');

  ActivityDate(this.date, this.type, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text(
              timeFormat.format(date),
              style: TextStyle(
                  color: color ?? ActivityAttribute
                      .attributeOf(type)
                      .color,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600),
            ),
            margin: EdgeInsets.only(bottom: 5, right: 3),
          ),
          Container(
            child: Text(
              dateFormat.format(date),
              style: TextStyle(
                  color: color ?? ActivityAttribute
                      .attributeOf(type)
                      .color,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600),
            ),
            margin: EdgeInsets.only(bottom: 5),
          ),
        ],
      ),
    );
  }
}