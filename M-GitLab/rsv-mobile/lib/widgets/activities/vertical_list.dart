import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/widgets/activities/item.dart';

class VerticalActivities extends StatelessWidget {

  VerticalActivities(context);

  Widget makeHeader(String headerText, {color}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        children: <Widget>[
          Text(
            headerText,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: color ?? Colors.black),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Activities>(builder: (context, activities, child) {
      var confirmationItems = activities.confirmationActivities;
      var currentItems = activities.currentActivities;
      var doneItems = activities.doneActivities;
      var skippedItems = activities.skippedActivities;
      return RefreshIndicator(
          onRefresh: () async {
            await activities.loadActivities();
          },
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  if (i == 0) {
                    return makeHeader('Ожидают подтверждения');
                  }
                  var item = confirmationItems[i - 1];
                  return ChangeNotifierProvider.value(
                    value: item,
                    child: ActivityItem(
                      axis: Axis.vertical,
                      item: item,
                    ),
                  );
                }, childCount: confirmationItems.length + 1),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  if (i == 0) {
                    return makeHeader('Предстоящие');
                  }
                  var item = currentItems[i - 1];
                  return ChangeNotifierProvider.value(
                    value: item,
                    child: ActivityItem(
                      axis: Axis.vertical,
                      item: item,
                    ),
                  );
                }, childCount: currentItems.length + 1),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  if (i == 0) {
                    return makeHeader('Прошедшие', color: Color(0xFF979797));
                  }
                  var item = doneItems[i - 1];
                  return ChangeNotifierProvider.value(
                    value: item,
                    child: ActivityItem(
                      axis: Axis.vertical,
                      item: item,
                    ),
                  );
                }, childCount: doneItems.length + 1),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  if (i == 0) {
                    return makeHeader('Пропущенные', color: Color(0xFFFC3A51));
                  }
                  var item = skippedItems[i - 1];
                  return ChangeNotifierProvider.value(
                    value: item,
                    child: ActivityItem(
                      axis: Axis.vertical,
                      item: item,
                    ),
                  );
                }, childCount: skippedItems.length + 1),
              ),
            ],
          ));
    });
  }
}
