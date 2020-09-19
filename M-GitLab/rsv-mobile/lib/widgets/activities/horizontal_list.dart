import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/widgets/activities/item.dart';

class HorizontalActivities extends StatelessWidget {
  HorizontalActivities(context);

  @override
  Widget build(BuildContext context) {
    return Consumer<Activities>(builder: (context, activities, child) {
      var items = activities.upcomingActivities;
      return items == null || items.isEmpty
          ? Center(
              child: Text(
                'Нет предстоящих активностей',
                style: TextStyle(fontSize: 18, color: const Color(0xFF979797)),
              ),
            )
          : SizedBox(
              height: 320.0,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, i) {
                  var item = items[i];
                  return ChangeNotifierProvider.value(
                    value: item,
                    child: ActivityItem(
                      axis: Axis.horizontal,
                      item: item,
                    ),
                  );
                },
              ));
    });
  }
}
