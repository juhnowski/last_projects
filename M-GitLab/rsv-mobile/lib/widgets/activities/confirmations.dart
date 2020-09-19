import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/widgets/activities/item.dart';

class ConfirmationActivities extends StatelessWidget {

  ConfirmationActivities(context);

  @override
  Widget build(BuildContext context) {
    return Consumer<Activities>(builder: (context, activities, child) {
      var items = activities.confirmationActivities;
      return items == null || items.isEmpty
          ? Center(
              child: Text(
                'Нет новых предложений',
                style: TextStyle(fontSize: 18, color: const Color(0xFF979797)),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: ChangeNotifierProvider.value(
                value: items[0],
                child: ActivityItem(
                  axis: Axis.horizontal,
                  item: items[0],
                ),
              ));
    });
  }
}