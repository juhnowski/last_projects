import 'package:flutter/widgets.dart';
import 'package:rsv_mobile/models/activities/activity.dart';

class ActivityIcon extends StatelessWidget {
  final ActivityType type;

  ActivityIcon(this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ActivityAttribute.attributeOf(type).color.withOpacity(0.2),
      ),
      child: Icon(
        ActivityAttribute.attributeOf(type).icon,
        color: ActivityAttribute.attributeOf(type).color,
        size: 18,
      ),
    );
  }
}
