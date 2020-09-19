import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class ActivityLabel extends StatelessWidget {
  final ActivityType type;
  final Color color;

  ActivityLabel(this.type, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: (color ?? ActivityAttribute.attributeOf(type).color)
              .withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        ActivityAttribute.attributeOf(type).title,
        style: TextStyle(
            color: color ?? ActivityAttribute.attributeOf(type).color,
            fontWeight: FontWeight.w700,
            fontSize: FontSize.small()),
      ),
      margin: EdgeInsets.only(bottom: 5),
    );
  }
}
